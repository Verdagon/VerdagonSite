
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
  echo "Fourth arg should be path to VmdSiteGen"
  exit 1
fi
VMD_SITE_GEN="$4"

echo $MODE $TARGET $VALESTROM

if [ $MODE == "build" ] ; then
  if [ $TARGET == "clean" ] || [ $TARGET == "all" ] ; then
    rm -rf public
    mkdir public
    mkdir public/components
    mkdir public/images
    mkdir public/blog
    mkdir public/grimoire
    mkdir public/releases
  fi
fi

if [ $TARGET == "home" ] || [ $TARGET == "all" ] ; then
  echo "Doing home"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/home src/home.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/home src/home.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "seamless-fearless-structured-concurrency" ] || [ $TARGET == "all" ] ; then
  echo "Doing seamless-fearless-structured-concurrency"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/seamless-fearless-structured-concurrency src/blog/seamless-fearless-structured-concurrency.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/seamless-fearless-structured-concurrency src/blog/seamless-fearless-structured-concurrency.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "comparing-hgm-traditional-reference-counting" ] || [ $TARGET == "all" ] ; then
  echo "Doing comparing-hgm-traditional-reference-counting"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/comparing-hgm-traditional-reference-counting src/blog/comparing-hgm-traditional-reference-counting.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/comparing-hgm-traditional-reference-counting src/blog/comparing-hgm-traditional-reference-counting.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "raii-next-steps" ] || [ $TARGET == "all" ] ; then
  echo "Doing raii-next-steps"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/raii-next-steps src/blog/raii-next-steps.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/raii-next-steps src/blog/raii-next-steps.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "cross-platform-core-vision" ] || [ $TARGET == "all" ] ; then
  echo "Doing cross-platform-core-vision"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/cross-platform-core-vision src/blog/cross-platform-core-vision.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/cross-platform-core-vision src/blog/cross-platform-core-vision.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "zero-cost-refs-regions" ] || [ $TARGET == "all" ] ; then
  echo "Doing zero-cost-refs-regions"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/zero-cost-refs-regions src/blog/zero-cost-refs-regions.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/zero-cost-refs-regions src/blog/zero-cost-refs-regions.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "grimoire" ] || [ $TARGET == "all" ] ; then
  echo "Doing grimoire"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/grimoire/grimoire src/grimoire/grimoire.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/grimoire/grimoire src/grimoire/grimoire.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "generational-references" ] || [ $TARGET == "all" ] ; then
  echo "Doing generational-references"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/generational-references src/blog/generational-references.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/generational-references src/blog/generational-references.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "hybrid-generational-memory" ] || [ $TARGET == "all" ] ; then
  echo "Doing hybrid-generational-memory"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/hybrid-generational-memory src/blog/hybrid-generational-memory.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/hybrid-generational-memory src/blog/hybrid-generational-memory.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "hgm-static-analysis-part-1" ] || [ $TARGET == "all" ] ; then
  echo "Doing hgm-static-analysis-part-1"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/hgm-static-analysis-part-1 src/blog/hgm-static-analysis-part-1.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/hgm-static-analysis-part-1 src/blog/hgm-static-analysis-part-1.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

# if [ $TARGET == "beyond-rust-innovations" ] || [ $TARGET == "all" ] ; then
#   echo "Doing beyond-rust-innovations"
#   echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/beyond-rust-innovations src/blog/beyond-rust-innovations.vmd
#   eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/beyond-rust-innovations src/blog/beyond-rust-innovations.vmd
#   if [ $? != 0 ]; then
#     echo "Failed!"
#     exit 1
#   fi
# fi

if [ $TARGET == "surprising-weak-refs" ] || [ $TARGET == "all" ] ; then
  echo "Doing surprising-weak-refs"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/surprising-weak-refs src/blog/surprising-weak-refs.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/surprising-weak-refs src/blog/surprising-weak-refs.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "python-data-races" ] || [ $TARGET == "all" ] ; then
  echo "Doing python-data-races"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/python-data-races src/blog/python-data-races.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/python-data-races src/blog/python-data-races.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $TARGET == "googler-to-traveler" ] || [ $TARGET == "all" ] ; then
  echo "Doing googler-to-traveler"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/googler-to-traveler src/blog/googler-to-traveler.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --out public/blog/googler-to-traveler src/blog/googler-to-traveler.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $MODE == "build" ] ; then
  echo "Copying..."
  cp src/*.css public
  cp src/rss.xml public
  cp src/components/*.css public/components
  cp src/EvanOvadia2022Resume812.pdf public/EvanOvadia2022Resume812.pdf
  cp src/EvanOvadiaResume2022Dev.pdf public/EvanOvadiaResume2022Dev.pdf
  cp src/components/*.js public/components
  cp src/components/*.png public/components
  cp src/images/* public/images
fi

echo "Done!"
