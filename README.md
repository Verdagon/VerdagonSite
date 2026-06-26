# VerdagonSite

Static site rendered by [VmdSiteGen](../VmdSiteGen) from `.vmd` source files in `src/`.

## Build

Three commands from a clean state. Adjust the paths if your sibling-repo layout differs (this assumes `Vale4/`, `VmdSiteGen/`, `VmdParse/`, `ParseIter/`, `Snippet/`, `VerdagonSite/` are siblings).

```bash
# 1. Build the Vale compiler (ask for where this is)

# 2. Compile VmdSiteGen via the Vale compiler.
valec build \
  --sanity_check false \
  --builtins_dir_override ../Vale4/Backend/builtins \
  vmdsitegen=../VmdSiteGen/src \
  vmdsitegencmd=../VmdSiteGen/cmd \
  vmdparse=../VmdParse/src \
  parseiter=../ParseIter/src \
  stdlib=../Vale4/stdlib/src \
  --output_dir ../VmdSiteGen/build \
  --region_override resilient-v3 \
  -o vmdsitegen

# 3. Render all pages.
rm -rf public && mkdir -p public/{components,images,blog,blog/next,grimoire,releases}
bash build.sh build all \
  ../VmdSiteGen/build/vmdsitegen \
  ../Snippet \
  ../VmdSiteGen/tools/highlighter/target/release/vmd-highlighter
```

Output lands in `public/` as bare filenames (no `.html` extension), one per `.vmd` source page.

## Single page

Replace `all` with a page name (e.g. `home`, `seamless-fearless-structured-concurrency`) — see `build.sh` for the full list.

## testvale mode

`bash build.sh testvale all ...` runs every code snippet through the compiler. Requires `VALESTROM=<dir containing valec>` in the env (typically `../Vale4/FrontendRust/target/debug`).
