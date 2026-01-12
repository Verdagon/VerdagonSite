# Thinking Through the Roguelike Example

## The Core Concept We're Trying to Capture

We want to demonstrate a pattern where:

1. **You have a mutable reference to part of a larger structure** (e.g., `&mut world.enemies[0]`)
2. **You want to call helper functions that read the whole structure** (e.g., `calculate_distance(&world)`)
3. **Rust forbids this** because you can't have `&mut world.enemies[?]` and `&world` simultaneously
4. **But it's actually safe!** The helper functions are pure/read-only; they won't invalidate your mutable reference
5. **Mojo's argument paths solve this** by tracking that your mutable reference is at `world.enemies[i]` and verifying no conflict

## The Key Insight

This showcases **deferred borrowing** in action:

- In Rust: You must choose between holding `&mut enemy` OR calling functions that need `&world`
- In Mojo: The compiler tracks that `enemy` points to `world.enemies[i]`, so when you call `calculate_distance(world)`, it can verify:
  - The function only reads `world`
  - Reading `world` doesn't conflict with your mutable borrow of `world.enemies[i]`
  - Therefore, it's safe!

## The Pattern We Want to Show

```rust
// Pure helper functions that naturally want to read the entire world
fn calculate_distance(world: &World) -> i32 { ... }
fn count_nearby_allies(world: &World, pos: Pos) -> usize { ... }
fn has_line_of_sight(world: &World, from: Pos, to: Pos) -> bool { ... }

// The function we naturally want to write
fn decide_enemy_action(enemy: &mut Enemy, world: &World) {
    // Call helpers that read the whole world
    let dist = calculate_distance(world, enemy.pos);  // ERROR in Rust!
    let allies = count_nearby_allies(world, enemy.pos);  // ERROR!
    let can_see = has_line_of_sight(world, enemy.pos, world.player.pos);  // ERROR!

    // Mutate enemy based on observations
    if dist < 2 && allies > 1 {
        enemy.courage += 10;
    } else if enemy.hp < 20 {
        enemy.fleeing = true;
    }
}

fn main() {
    let mut world = World { ... };

    // This fails in Rust!
    decide_enemy_action(&mut world.enemies[0], &world);
    // ERROR: cannot borrow `world` as immutable because
    //        `world.enemies[?]` is already borrowed as mutable
}
```

## Why This is Pedagogically Powerful

1. **The helpers are obviously pure** - They just read positions, count things, check line-of-sight. No mutation.
2. **The pattern is natural** - This is how you'd want to structure the code: composable helpers.
3. **Rust's restriction feels arbitrary** - "Why can't I read the world? I'm just looking at positions!"
4. **Workarounds all have costs** - Inlining (duplication), passing pieces (verbose), using indices (overhead)
5. **Mojo's solution is elegant** - With argument paths, the natural version just works.

## The 5 Roguelike Options

### Option 1: Regeneration/Status Effects
```rust
struct Player { hp: i32, pos: Pos, ... }
struct Dungeon { current_floor: Floor, biome: Biome, ... }
struct World { player: Player, dungeon: Dungeon, ... }

fn get_regen_rate(world: &World, pos: Pos) -> i32 {
    // Read dungeon properties to calculate regen
    match world.dungeon.biome {
        Biome::Forest => 2,
        Biome::Desert => 0,
        Biome::Shrine => 5,
    }
}

fn apply_regen(player: &mut Player, world: &World) {
    let regen = get_regen_rate(world, player.pos);  // ERROR!
    player.hp += regen;
}

// Call: apply_regen(&mut world.player, &world)  // FAILS
```

**Pros:**
- Simple, easy to understand
- Regen rate based on environment is intuitive

**Cons:**
- Only one helper function
- Less compelling than multiple queries

**Rating:** 6/10 - Too simple

---

### Option 2: Line-of-Sight Combat
```rust
struct Player { pos: Pos, base_damage: i32, stamina: i32, ... }
struct Enemy { pos: Pos, hp: i32, ... }
struct World { player: Player, enemies: Vec<Enemy>, ... }

fn is_adjacent(pos1: Pos, pos2: Pos) -> bool { ... }

fn count_adjacent_enemies(world: &World, pos: Pos) -> usize {
    world.enemies.iter()
        .filter(|e| is_adjacent(pos, e.pos))
        .count()
}

fn calculate_attack_damage(attacker: &mut Player, world: &World) -> i32 {
    let mut damage = attacker.base_damage;

    let adjacent = count_adjacent_enemies(world, attacker.pos);  // ERROR!
    damage += adjacent as i32 * 5;  // flanking bonus

    attacker.stamina -= 10;  // use stamina
    damage
}

// Call: calculate_attack_damage(&mut world.player, &world)  // FAILS
```

**Pros:**
- Combat is core to roguelikes
- Flanking mechanics are realistic

**Cons:**
- The mutation (stamina) feels a bit tacked on
- Could be structured differently (return damage, apply stamina separately)

**Rating:** 7/10 - Good but not great

---

### Option 3: Environmental Hazards
```rust
struct Player { pos: Pos, hp: i32, poison_stacks: i32, speed: f32, ... }
struct Tile { pos: Pos, hazard: Hazard, ... }
struct Dungeon { tiles: Vec<Vec<Tile>>, ... }
struct World { player: Player, dungeon: Dungeon, ... }

fn get_tile(world: &World, pos: Pos) -> &Tile {
    &world.dungeon.tiles[pos.y][pos.x]
}

fn apply_environmental_effects(player: &mut Player, world: &World) {
    let tile = get_tile(world, player.pos);  // ERROR!

    match tile.hazard {
        Hazard::Fire => player.hp -= 5,
        Hazard::Poison => player.poison_stacks += 1,
        Hazard::Ice => player.speed *= 0.5,
        Hazard::None => {}
    }
}

// Call: apply_environmental_effects(&mut world.player, &world)  // FAILS
```

**Pros:**
- Environmental hazards are standard in roguelikes
- Clear read-then-mutate pattern

**Cons:**
- Only one helper (get_tile)
- Pretty simple logic

**Rating:** 6/10 - Too simple

---

### Option 4: AI Decision Making ⭐ FAVORITE
```rust
struct Enemy { pos: Pos, hp: i32, courage: i32, fleeing: bool, ... }
struct Player { pos: Pos, ... }
struct World { player: Player, enemies: Vec<Enemy>, dungeon: Dungeon, ... }

fn calculate_distance_to_player(world: &World, from: Pos) -> i32 {
    let dx = world.player.pos.x - from.x;
    let dy = world.player.pos.y - from.y;
    ((dx * dx + dy * dy) as f32).sqrt() as i32
}

fn count_nearby_allies(world: &World, pos: Pos, range: i32) -> usize {
    world.enemies.iter()
        .filter(|e| {
            let dx = e.pos.x - pos.x;
            let dy = e.pos.y - pos.y;
            dx * dx + dy * dy < range * range
        })
        .count()
}

fn has_line_of_sight(world: &World, from: Pos, to: Pos) -> bool {
    // Check if path is clear in dungeon
    // (simplified - real LOS would raycast through tiles)
    !world.dungeon.has_wall_between(from, to)
}

fn decide_enemy_action(enemy: &mut Enemy, world: &World) -> Action {
    let dist = calculate_distance_to_player(world, enemy.pos);  // ERROR!
    let allies = count_nearby_allies(world, enemy.pos, 3);  // ERROR!
    let can_see = has_line_of_sight(world, enemy.pos, world.player.pos);  // ERROR!

    // Update enemy state based on observations
    if dist < 2 && allies > 1 {
        enemy.courage += 10;  // brave with friends nearby
        Action::Attack
    } else if enemy.hp < 20 {
        enemy.fleeing = true;
        Action::Flee
    } else if can_see {
        Action::Approach
    } else {
        Action::Wander
    }
}

// Call: decide_enemy_action(&mut world.enemies[0], &world)  // FAILS
```

**Pros:**
- **Multiple pure helper functions** - Really showcases the composability problem
- **Realistic AI logic** - This is how you'd actually write enemy behavior
- **Clear mutations** - courage, fleeing flags make sense to update
- **Obvious that helpers are safe** - They just read positions and count things
- **Great for showing workarounds** - Each workaround's cost is clear

**Cons:**
- Slightly more complex to set up

**Rating:** 10/10 - PERFECT for our use case

---

### Option 5: Inventory Weight/Encumbrance
```rust
struct Item { name: String, weight: i32, ... }
struct Player { inventory: Vec<Item>, stamina: i32, ... }
struct GameRules { max_carry_weight: i32, difficulty_multiplier: f32, ... }
struct World { player: Player, rules: GameRules, ... }

fn calculate_total_weight(world: &World) -> i32 {
    world.player.inventory.iter()
        .map(|i| i.weight)
        .sum()
}

fn get_stamina_cost(world: &World, item_weight: i32) -> i32 {
    (item_weight as f32 * world.rules.difficulty_multiplier) as i32
}

fn pickup_item(player: &mut Player, item: Item, world: &World) -> Result<(), String> {
    let total_weight = calculate_total_weight(world);  // ERROR!

    if total_weight + item.weight > world.rules.max_carry_weight {  // ERROR!
        return Err("Too heavy!".into());
    }

    let stamina_cost = get_stamina_cost(world, item.weight);  // ERROR!
    player.stamina -= stamina_cost;
    player.inventory.push(item);

    Ok(())
}

// Call: pickup_item(&mut world.player, item, &world)  // FAILS
```

**Pros:**
- Inventory is a core roguelike mechanic
- Multiple helpers reading world state

**Cons:**
- The helpers feel a bit contrived (why does calculate_total_weight need &World instead of just &Player.inventory?)
- Less obviously "natural" than AI

**Rating:** 7/10 - Good but helpers feel forced

---

## Recommendation

**Go with Option 4: AI Decision Making**

Why?
1. **Multiple pure helper functions** that obviously should take `&World`
2. **Natural, idiomatic code structure** - this is how you'd want to write it
3. **Clear pedagogical story**:
   - Show the natural way (fails in Rust)
   - Show 3-4 workarounds and their costs
   - Show how Mojo's argument paths make the natural way work
4. **Realistic** - anyone who's written game AI will recognize this pattern
5. **Easy to understand** - no domain expertise needed to grasp "enemy decides action based on distance to player and nearby allies"

## Next Steps

1. Implement the full example in `example_roguelike.rs`
2. Show it failing in Rust
3. Show typical workarounds (inlining, indices, refactoring)
4. Comment on what Mojo would allow
5. Maybe create a corresponding `example_roguelike.mojo` showing it working?
