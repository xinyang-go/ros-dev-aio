ARG ROS_DISTRO=noetic
FROM ros:$ROS_DISTRO
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
# create user
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME
# setup ros enviroment
RUN echo source /opt/ros/$ROS_DISTRO/setup.bash >> /home/$USERNAME/.bashrc
