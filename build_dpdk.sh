#!/bin/bash

################################################################################
#
#  build_dpdk.sh
#
#             - Build DPDK and pktgen-dpdk for Ubuntu
#
#  Usage:     Adjust variables below before running, if necessary.
#
#  MAINTAINER:  jeder@redhat.com
#
################################################################################

################################################################################
#  Define Global Variables and Functions
################################################################################

DPDK_VERSION=20.11.9
PKTGEN_VERSION=21.11.0
BASEDIR=/root
DPDK_DIR=$BASEDIR/dpdk-stable-$DPDK_VERSION
PKTGEN_DIR=$BASEDIR/pktgen-$PKTGEN_VERSION
CONFIG=x86_64-native-linuxapp-gcc

# Download/Build DPDK
cd $BASEDIR
curl -L http://fast.dpdk.org/rel/dpdk-$DPDK_VERSION.tar.xz | tar xJ
cd $DPDK_DIR

# Configure and build DPDK
meson build
cd build
ninja
ninja install
ldconfig

# Set environment variables
export RTE_SDK=$DPDK_DIR
export RTE_TARGET=$CONFIG

# Download/Build pktgen-dpdk
cd $BASEDIR
curl -L http://git.dpdk.org/apps/pktgen-dpdk/snapshot/pktgen-$PKTGEN_VERSION.tar.gz | tar xz
cd $PKTGEN_DIR
make

# Create symbolic link
ln -s $PKTGEN_DIR/app/app/$CONFIG/pktgen /usr/bin/