#!/bin/bash
WD=$(pwd)
LUAJIT_DIR=$WD/luajit
LUASOCKET_DIR=$WD/luasocket
LUA_DIR=$LUAJIT_DIR/out
MPV_FILES=$WD/mpv
MAKE=mingw32-make.exe

mkdir -p $LUA_DIR
mkdir -p $MPV_FILES

# build luajit
cd $LUAJIT_DIR
git am --3way $WD/luajit-0001-add-win32-utf-8-filesystem-functions.patch
cd ..

$MAKE -C $LUAJIT_DIR clean
$MAKE -C $LUAJIT_DIR \
  CC='gcc -m64' \
  PREFIX=$LUA_DIR \
  TARGET_SYS=Windows \
  BUILDMODE=dynamic \
  CFLAGS='-D_WIN32_WINNT=0x0602 -DUNICODE' \
  XCFLAGS='-DLUAJIT_ENABLE_LUA52COMPAT' \
  install

cp $LUAJIT_DIR/src/lua51.dll $MPV_FILES

# build luasocket
$MAKE -C $LUASOCKET_DIR clean
$MAKE -C $LUASOCKET_DIR \
  PLAT=mingw \
  LUAINC_mingw=$LUA_DIR/include/luajit-2.1 \
  LUALIB_mingw=$MPV_FILES/lua51.dll \
  DEF_mingw=-DWINVER=0x0602 \
  LUAPREFIX_mingw=$MPV_FILES \
  LDIR=lua \
  CDIR=. \
  mingw install

cp -v $LUAJIT_DIR/COPYRIGHT $MPV_FILES/LUAJIT-LICENSE
cp -v $LUASOCKET_DIR/LICENSE $MPV_FILES/LUASOCKET-LICENSE

# cd $MPV_FILES
# tar -zcvf $WD/mpv.tar.gz *
