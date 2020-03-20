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

$MAKE clean
$MAKE PREFIX=$LUA_DIR TARGET_SYS=Windows BUILDMODE=dynamic install
cp $LUAJIT_DIR/src/lua51.dll $MPV_FILES

# build luasocket
cd $LUASOCKET_DIR

$MAKE clean
$MAKE \
	PLAT=mingw \
	LUAINC_mingw=$LUA_DIR/include/luajit-2.0 \
	LUALIB_mingw=$MPV_FILES/lua51.dll \
	LUAPREFIX_mingw=$MPV_FILES \
	LDIR=lua \
	CDIR=. \
	mingw install
