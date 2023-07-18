ARG ROS_DISTRO=noetic
FROM osrf/ros:$ROS_DISTRO-desktop-full
# set deb non-interactive
ENV DEBIAN_FRONTEND=noninteractive
# install basic tools
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y software-properties-common apt-utils \
                          bash-completion wget curl vim git jq sudo \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# install gcc
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y gcc-11 g++-11 gdb ccache build-essential ninja-build \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11 \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# install clangd
RUN wget https://apt.llvm.org/llvm.sh \
    && bash llvm.sh 16 \
    && rm llvm.sh \
    && apt-get autoremove -y clang-16 lldb-16 lld-16 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 
ENV PATH="/usr/lib/llvm-16/bin:${PATH}"
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
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# install ceres-solver
RUN apt-get update && sudo apt-get install -y libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev \
    && wget -q -O - http://ceres-solver.org/ceres-solver-2.1.0.tar.gz | tar -zxv \
    && cd ceres-solver-2.1.0 && cmake -B build && cmake --build build && cmake --install build \
    && cd .. && rm ceres-solver-2.1.0 -rf \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
