ARG ROS_DISTRO=noetic
FROM osrf/ros:$ROS_DISTRO-desktop-full
# set deb non-interactive
ENV DEBIAN_FRONTEND=noninteractive
# set time zone
ENV TZ=Asia/Shanghai
# install basic tools
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y software-properties-common apt-utils \
                          bash-completion wget curl vim git sudo \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# install gcc-11
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y gcc-11 g++-11 gdb ccache build-essential ninja-build \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11 \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# install llvm-17
RUN wget https://apt.llvm.org/llvm.sh \
    && bash llvm.sh 17 all \
    && rm llvm.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
ENV PATH="/usr/lib/llvm-17/bin:${PATH}"
# install cmake
RUN wget https://apt.kitware.com/kitware-archive.sh \
    && bash kitware-archive.sh \
    && apt-get install -y cmake \
    && rm kitware-archive.sh \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# install libraries
RUN apt-get update \
    && apt-get install -y ros-${ROS_DISTRO}-pcl-ros ros-${ROS_DISTRO}-vision-opencv \
                          ros-${ROS_DISTRO}-rosbridge-suite ros-${ROS_DISTRO}-foxglove-bridge \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
