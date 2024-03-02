ARG ROS_DISTRO=noetic
FROM osrf/ros:$ROS_DISTRO-desktop-full
# set deb non-interactive
ARG DEBIAN_FRONTEND=noninteractive
# set time zone
ENV TZ=Asia/Shanghai
# install basic tools
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y software-properties-common apt-utils \
                          bash-completion wget curl vim git sudo tmux \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
# install gcc-11
RUN if [ $ROS_DISTRO = "humble" ]; then GCC_VER=13; else GCC_VER=11; fi \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y gcc-$GCC_VER g++-$GCC_VER gdb ccache build-essential ninja-build \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$GCC_VER $GCC_VER \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-$GCC_VER $GCC_VER \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
# install llvm-18
RUN wget https://apt.llvm.org/llvm.sh \
    && bash llvm.sh 18 all \
    && rm llvm.sh \
    && rm -rf /var/lib/apt/lists/* 
ENV PATH="/usr/lib/llvm-18/bin:${PATH}"
# install cmake
RUN wget https://apt.kitware.com/kitware-archive.sh \
    && bash kitware-archive.sh \
    && apt-get install -y cmake \
    && rm kitware-archive.sh \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
# install libraries
RUN apt-get update \
    && apt-get install -y ros-${ROS_DISTRO}-pcl-ros ros-${ROS_DISTRO}-vision-opencv \
                          ros-${ROS_DISTRO}-rosbridge-suite ros-${ROS_DISTRO}-foxglove-bridge \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
