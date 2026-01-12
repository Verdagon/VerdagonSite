use Directive::PursueDirective;
use Directive::LoiterDirective;

struct Path {
    steps: Vec<Location>
}
impl Clone for Path {
    fn clone(&self) -> Path {
        let mut result = Path { steps: Vec::new() };
        // TODO
        return result;
    }
}

#[derive(Clone, PartialEq)]
struct Location {
    row: usize,
    col: usize
}

struct Tile {
    walkable: bool
}

#[derive(Clone)]
struct Pursue {
    enemy_id: usize,
    enemy_last_seen_loc: Location,
    path: Path
}

#[derive(Clone)]
enum Directive {
    LoiterDirective,
    PursueDirective(Pursue)
}

struct Entity {
    loc: Location,
    is_blinded: bool,
    directive: Directive
}

struct World {
    entities: Vec<Entity>,
    tiles: Tile, // TODO change to Vec<Vec<Tile>>
}
impl World {
    fn tile_at(&self, loc: &Location) -> &Tile {
        return &self.tiles
    }
}

impl World {
  fn has_line_of_sight(&self, from: &Location, to: &Location) -> bool {
    return true // TODO: impl
  }
}

fn find_path(world: &World, from: &Location, to: &Location) -> Path {
    return Path { steps: Vec::new() }; // TODO
}

fn can_see_loc(world: &World, entity: &Entity, loc: &Location) -> bool {
    return !entity.is_blinded &&
        world.has_line_of_sight(&entity.loc, loc);
}

// Entity looks around and thinks and decides their objective
fn plan(world: &mut World, entity_id: usize) {
    let entity_read = &world.entities[entity_id];

    // if there's an existing directive, check it and see if it even makes sense anymore.
    // In which case, set to loiter.
    // TODO: try to get rid of this clone. then we'll have a mut ref supposedly and we can overwrite it
    match entity_read.directive.clone() {
        LoiterDirective => {}
        PursueDirective(existing_pursue) => {
            let enemy_loc = world.entities[existing_pursue.enemy_id].loc.clone();

            if can_see_loc(&world, entity_read, &enemy_loc) {
                // we store path to the enemy. keep the path around so we
                // dont have to recalculate it every turn, just recalculate
                // if we run into something.
                let new_path = find_path(&world, &entity_read.loc, &enemy_loc);
                if new_path.steps.len() == 0 {
                    // we see them but can't get to them. loiter instead.
                    // need to re-fetch because we need to mutate.
                    // Mention: ironically, this is why vale did its gen ref thing.
                    let entity_mut = &mut world.entities[entity_id];
                    entity_mut.directive = LoiterDirective;
                } else if !world.tile_at(&new_path.steps[0]).walkable {
                    // next step is unwalkable for some reason, stop
                    // need to re-fetch because we need to mutate.
                    let entity_mut = &mut world.entities[entity_id];
                    entity_mut.directive = LoiterDirective;
                } else { // there's a path to the enemy
                    // keep pursuing
                    let entity_mut = &mut world.entities[entity_id];
                    entity_mut.directive = PursueDirective(Pursue {
                        enemy_id: existing_pursue.enemy_id,
                        enemy_last_seen_loc: enemy_loc,
                        path: new_path
                    });
                }
            } else { // can't see the player
                if entity_read.loc == existing_pursue.enemy_last_seen_loc {
                    // we're where we last saw them. give up.
                    // need to re-fetch because we need to mutate.
                    let entity_mut = &mut world.entities[entity_id];
                    entity_mut.directive = LoiterDirective;
                } else {
                    // keep pursuing
                    let entity_mut = &mut world.entities[entity_id];
                    entity_mut.directive = PursueDirective(Pursue {
                        enemy_id: existing_pursue.enemy_id,
                        enemy_last_seen_loc: enemy_loc,
                        path: existing_pursue.path
                    });
                }
            }
        }
    }
}

fn main() {

}