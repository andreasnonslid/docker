# Use OpenSUSE Tumbleweed as the base image
FROM opensuse/tumbleweed

# Set default argument values
ARG TOOLCHAIN=gnu

# Install common development tools and libraries
RUN zypper --non-interactive refresh && \
    zypper --non-interactive install -y \
    make \
    cmake \
    ninja \
    clang \
    gdb \
    gcovr \
    python3 \
    python3-pip

# Conditionally install GNU toolchain if TOOLCHAIN is set to 'gnu'
RUN if [ "$TOOLCHAIN" = "gnu" ]; then \
        zypper --non-interactive install -y \
        gcc \
        gcc-c++ \
        libstdc++6 \
        binutils \
        ; \
    fi


# Conditionally install LLVM toolchain if TOOLCHAIN is set to 'llvm'
RUN if [ "$TOOLCHAIN" = "llvm" ]; then \
        zypper --non-interactive install -y \
        lld \
        llvm \
        libc++1 \
        libc++-devel \
        ; \
    fi

RUN zypper clean --all

# Set Python 3 as the default python command
RUN ln -sf python3 /usr/bin/python
# Add ninja-build to PATH if needed
ENV PATH=$PATH:/usr/lib/ninja-build/bin

LABEL description="GNU or LLVM Toolchain with Clang and related tools on OpenSUSE Tumbleweed"

WORKDIR /app
