
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

if [ "$5" == "" ] ; then
  echo "Fifth arg should be path to stdlib"
  exit 1
fi
STDLIB="$5"

echo $MODE $TARGET $VALESTROM $STDLIB

if [ $MODE == "build" ] ; then
  if [ $TARGET == "clean" ] || [ $TARGET == "all" ] ; then
    rm -rf public
    mkdir public
    mkdir public/components
    mkdir public/images
    mkdir public/blog
    mkdir public/releases
  fi
fi

if [ $TARGET == "seamless-fearless-structured-concurrency" ] || [ $TARGET == "all" ] ; then
  echo "Doing seamless-fearless-structured-concurrency"
  echo $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --stdlib_dir $STDLIB/src --out public/blog/seamless-fearless-structured-concurrency src/blog/seamless-fearless-structured-concurrency.vmd
  eval $VMD_SITE_GEN/build/vmdsitegen $MODE --compiler_dir $VALESTROM --stdlib_dir $STDLIB/src --out public/blog/seamless-fearless-structured-concurrency src/blog/seamless-fearless-structured-concurrency.vmd
  if [ $? != 0 ]; then
    echo "Failed!"
    exit 1
  fi
fi

if [ $MODE == "build" ] ; then
  echo "Copying..."
  cp src/*.css public
  cp src/components/*.css public/components
  cp src/components/*.js public/components
  cp src/components/*.png public/components
  cp src/images/* public/images
fi

echo "Done!"
