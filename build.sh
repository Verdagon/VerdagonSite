
if [ "$1" == "" ] ; then
  echo "First arg should be 'build' or 'testvale'"
  exit 1
fi
MODE="$1"

if [ "$2" == "" ] ; then
  echo "Second arg should be 'all' or a page name"
  exit 1
fi
TARGET="$2"

if [ "$3" == "" ] ; then
  echo "Third arg should be path to Valestrom.jar"
  exit 1
fi
VALESTROM="$3"

if [ "$4" == "" ] ; then
  echo "Fourth arg should be path to VmdSiteGen program"
  exit 1
fi
VMD_SITE_GEN="$4"

if [ "$5" == "" ] ; then
  echo "Fifth arg should be path to Snippet dir"
  exit 1
fi
SNIPPET_DIR="$5"

if [ $MODE == "build" ] ; then
  if [ $TARGET == "clean" ] || [ $TARGET == "all" ] ; then
    rm -rf public
    mkdir public
    mkdir public/components
    mkdir public/images
    mkdir public/blog
    mkdir public/blog
    mkdir public/blog/next
    mkdir public/grimoire
    mkdir public/releases
  fi
fi

if [ $TARGET == "home" ] || [ $TARGET == "all" ] ; then
  echo "Doing home"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/home src/home.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/home src/home.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "seamless-fearless-structured-concurrency" ] || [ $TARGET == "all" ] ; then
  echo "Doing seamless-fearless-structured-concurrency"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/seamless-fearless-structured-concurrency src/blog/vision/seamless-fearless-structured-concurrency.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/seamless-fearless-structured-concurrency src/blog/vision/seamless-fearless-structured-concurrency.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "comparing-hgm-traditional-reference-counting" ] || [ $TARGET == "all" ] ; then
  echo "Doing comparing-hgm-traditional-reference-counting"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/comparing-hgm-traditional-reference-counting src/blog/thoughts/comparing-hgm-traditional-reference-counting.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/comparing-hgm-traditional-reference-counting src/blog/thoughts/comparing-hgm-traditional-reference-counting.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "when-to-use-memory-safe-part-1" ] || [ $TARGET == "all" ] ; then
  echo "Doing when-to-use-memory-safe-part-1"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/when-to-use-memory-safe-part-1 src/blog/memory-safe-languages/when-to-use-memory-safe-part-1.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/when-to-use-memory-safe-part-1 src/blog/memory-safe-languages/when-to-use-memory-safe-part-1.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "generics-hash-codes-madness" ] || [ $TARGET == "all" ] ; then
  echo "Doing generics-hash-codes-madness"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/generics-hash-codes-madness src/blog/0.3/generics-hash-codes-madness.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/generics-hash-codes-madness src/blog/0.3/generics-hash-codes-madness.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "probabilistic-memory-safety" ] || [ $TARGET == "all" ] ; then
  echo "Doing probabilistic-memory-safety"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/probabilistic-memory-safety src/blog/thoughts/probabilistic-memory-safety.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/probabilistic-memory-safety src/blog/thoughts/probabilistic-memory-safety.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "raii-next-steps" ] || [ $TARGET == "all" ] ; then
  echo "Doing raii-next-steps"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/raii-next-steps src/blog/retired/raii-next-steps.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/raii-next-steps src/blog/retired/raii-next-steps.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "cross-platform-core-vision" ] || [ $TARGET == "all" ] ; then
  echo "Doing cross-platform-core-vision"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/cross-platform-core-vision src/blog/retired/cross-platform-core-vision.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/cross-platform-core-vision src/blog/retired/cross-platform-core-vision.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "zero-cost-refs-regions" ] || [ $TARGET == "all" ] ; then
  echo "Doing zero-cost-refs-regions"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/zero-cost-refs-regions src/blog/retired/zero-cost-refs-regions.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/zero-cost-refs-regions src/blog/retired/zero-cost-refs-regions.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "grimoire" ] || [ $TARGET == "all" ] ; then
  echo "Doing grimoire"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/grimoire/grimoire src/grimoire/grimoire.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/grimoire/grimoire src/grimoire/grimoire.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "generational-references" ] || [ $TARGET == "all" ] ; then
  echo "Doing generational-references"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/generational-references src/blog/retired/generational-references.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/generational-references src/blog/retired/generational-references.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "hybrid-generational-memory" ] || [ $TARGET == "all" ] ; then
  echo "Doing hybrid-generational-memory"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/hybrid-generational-memory src/blog/retired/hybrid-generational-memory.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/hybrid-generational-memory src/blog/retired/hybrid-generational-memory.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "hgm-static-analysis-part-1" ] || [ $TARGET == "all" ] ; then
  echo "Doing hgm-static-analysis-part-1"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/hgm-static-analysis-part-1 src/blog/retired/hgm-static-analysis-part-1.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/hgm-static-analysis-part-1 src/blog/retired/hgm-static-analysis-part-1.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "observer-challenge" ] || [ $TARGET == "all" ] ; then
  echo "Doing observer-challenge"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/observer-challenge src/blog/architecture/observer-challenge.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/observer-challenge src/blog/architecture/observer-challenge.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
  cp src/blog/observer-challenge-example.js public/blog/observer-challenge-example.js
fi

if [ $TARGET == "observer-challenge-conclusions" ] || [ $TARGET == "all" ] ; then
  echo "Doing observer-challenge-conclusions"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/observer-challenge-conclusions src/blog/architecture/observer-challenge-conclusions.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/observer-challenge-conclusions src/blog/architecture/observer-challenge-conclusions.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "surprising-weak-refs" ] || [ $TARGET == "all" ] ; then
  echo "Doing surprising-weak-refs"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/surprising-weak-refs src/blog/retired/surprising-weak-refs.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/surprising-weak-refs src/blog/retired/surprising-weak-refs.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "yak-shave-language-engine-game" ] || [ $TARGET == "all" ] ; then
  echo "Doing yak-shave-language-engine-game"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/yak-shave-language-engine-game src/blog/yak-shave-language-engine-game.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/yak-shave-language-engine-game src/blog/yak-shave-language-engine-game.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "python-data-races" ] || [ $TARGET == "all" ] ; then
  echo "Doing python-data-races"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/python-data-races src/blog/retired/python-data-races.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/python-data-races src/blog/retired/python-data-races.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "googler-to-traveler" ] || [ $TARGET == "all" ] ; then
  echo "Doing googler-to-traveler"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/googler-to-traveler src/blog/thoughts/googler-to-traveler.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/googler-to-traveler src/blog/thoughts/googler-to-traveler.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "higher-raii-7drl" ] || [ $TARGET == "all" ] ; then
  echo "Doing higher-raii-7drl"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/higher-raii-7drl src/blog/vision/higher-raii-7drl.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/higher-raii-7drl src/blog/vision/higher-raii-7drl.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "first-100k-lines" ] || [ $TARGET == "all" ] ; then
  echo "Doing first-100k-lines"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/first-100k-lines src/blog/0.2/first-100k-lines.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/first-100k-lines src/blog/0.2/first-100k-lines.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "on-removing-let-let-mut" ] || [ $TARGET == "all" ] ; then
  echo "Doing on-removing-let-let-mut"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/on-removing-let-let-mut src/blog/0.2/on-removing-let-let-mut.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/on-removing-let-let-mut src/blog/0.2/on-removing-let-let-mut.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "concept-functions" ] || [ $TARGET == "all" ] ; then
  echo "Doing concept-functions"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/concept-functions src/blog/0.2/concept-functions.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/concept-functions src/blog/0.2/concept-functions.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "perfect-replayability-prototyped" ] || [ $TARGET == "all" ] ; then
  echo "Doing perfect-replayability-prototyped"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/perfect-replayability-prototyped src/blog/0.2/perfect-replayability-prototyped.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/perfect-replayability-prototyped src/blog/0.2/perfect-replayability-prototyped.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "fearless-ffi" ] || [ $TARGET == "all" ] ; then
  echo "Doing fearless-ffi"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/fearless-ffi src/blog/0.2/fearless-ffi.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/fearless-ffi src/blog/0.2/fearless-ffi.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "const-generics-spread" ] || [ $TARGET == "all" ] ; then
  echo "Doing const-generics-spread"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/const-generics-spread src/blog/0.2/const-generics-spread.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/const-generics-spread src/blog/0.2/const-generics-spread.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "version-0.2-released" ] || [ $TARGET == "all" ] ; then
  echo "Doing version-0.2-released"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/version-0.2-released src/blog/0.2/version-0.2-released.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/version-0.2-released src/blog/0.2/version-0.2-released.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "regions-1-pure-functions" ] || [ $TARGET == "all" ] ; then
  echo "Doing regions-1-pure-functions"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/zero-cost-memory-safety-regions-part-1-pure-functions src/blog/vision/regions-1-pure-functions.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/zero-cost-memory-safety-regions-part-1-pure-functions src/blog/vision/regions-1-pure-functions.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "next-gen-languages-gpu" ] || [ $TARGET == "all" ] ; then
  echo "Doing regions-1-pure-functions"
  echo $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/next-gen-languages-gpu src/blog/next/next-gen-languages-gpu.vmd
  eval $VMD_SITE_GEN $MODE --compiler_dir $VALESTROM --out public/blog/next-gen-languages-gpu src/blog/next/next-gen-languages-gpu.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi



if [ $MODE == "build" ] ; then
  echo "Copying..."
  cp src/*.css public
  cp src/rss.xml public
  cp src/sponsors.xml public
  cp src/components/*.css public/components
  cp $SNIPPET_DIR/css/*.css public/components
  cp src/EvanOvadia2022Resume812.pdf public/EvanOvadia2022Resume812.pdf
  cp src/EvanOvadiaResume2022Dev.pdf public/EvanOvadiaResume2022Dev.pdf
  cp src/components/*.js public/components
  cp src/components/*.png public/components
  cp src/images/* public/images
fi

echo "Done!"
