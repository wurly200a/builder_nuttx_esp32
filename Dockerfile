FROM ubuntu:22.04

ARG USER_NAME="builder"
ARG GROUP_NAME="builder"
ARG IMAGE_NAME

RUN if [ -z "${USER_NAME}"  ] || \
       [ -z "${IMAGE_NAME}"   ];   \
    then echo "Please specify args"; \
    exit 1; \
    fi

# basic
RUN apt update -y

# add user and group
RUN groupadd ${GROUP_NAME}
RUN useradd -g ${GROUP_NAME} -m ${USER_NAME}

# NuttX Prerequisites
RUN apt install -y \
    bison flex gettext texinfo libncurses5-dev libncursesw5-dev xxd \
    gperf automake libtool pkg-config build-essential gperf genromfs \
    libgmp-dev libmpc-dev libmpfr-dev libisl-dev binutils-dev libelf-dev \
    libexpat-dev gcc-multilib g++-multilib picocom u-boot-tools util-linux

# NuttX Kconfig frontend
RUN apt install -y kconfig-frontends

# NuttX Toolchain
RUN apt install -y gcc-arm-none-eabi binutils-arm-none-eabi

# ESP-IDF Prerequisites
RUN apt install -y git wget flex bison gperf python3 python3-venv cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

# Get ESP-IDF
USER ${USER_NAME}
RUN mkdir -p ~/esp
RUN git clone --recursive https://github.com/espressif/esp-idf.git -b v5.3 ~/esp/esp-idf

# ESP-IDF Set up the tools
RUN ~/esp/esp-idf/install.sh esp32
RUN echo "alias get_idf='. $HOME/esp/esp-idf/export.sh'" > ~/.bash_aliases

# Set Prompt
RUN echo PS1="'(docker)${IMAGE_NAME}:\w${PS1}'" >> ~/.bashrc
