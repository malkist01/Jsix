#!/bin/bash

#SETUP BUILD ENVIRONMENT
export ARCH=arm
export PATH=/home/noob/kernel/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9/bin:$PATH

#CLEAN SOURCE
OUTDIR=out
rm -rf $OUTDIR
mkdir $OUTDIR
make clean $OUTDIR && make mrproper $OUTDIR

#MAKE DEFCONFIG
CCV="CROSS_COMPILE=arm-linux-androideabi-"
ODV="O=$OUTDIR"
make -C $(pwd) $ODV $CCV j4primelte_defconfig

#GET CPU COUNT
CORE_COUNT=$(grep -c processor /proc/cpuinfo)

#BUILD KERNEL AND SEND ERRORS TO erros.log
# stdout still prints to console, stderr goes to erros.log
make -j$CORE_COUNT -C $(pwd) $ODV $CCV 2> erros.log | tee build.log

#COPY zImage IF BUILD SUCCEEDS
if [ -f "$OUTDIR/arch/arm/boot/zImage" ]; then
    cp $OUTDIR/arch/arm/boot/zImage $(pwd)/arch/arm/boot/zImage
    echo "Build finished: zImage copied."
else
    echo "Build failed, check erros.log for details."
fi
