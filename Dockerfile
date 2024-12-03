FROM ccr.ccs.tencentyun.com/library/ubuntu:20.04

MAINTAINER Your Name <your.email@example.com>

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# Update package sources to use Tencent Cloud mirrors
RUN sed -i 's/archive.ubuntu.com/mirrors.cloud.tencent.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.cloud.tencent.com/g' /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get install -y \
    sudo \
    libhugetlbfs-bin \
    libpcap-dev \
    linux-headers-generic \
    build-essential \
    curl \
    python3 \
    python3-pip \
    pkg-config \
    ninja-build \
    meson \
    libnuma-dev \
    libpcap0.8-dev \
    tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /root

# Copy build script and profile
COPY ./build_dpdk.sh /root/build_dpdk.sh
COPY ./dpdk-profile.sh /etc/profile.d/

# Build DPDK
RUN chmod +x /root/build_dpdk.sh && /root/build_dpdk.sh

# Verify DPDK installation on container start
CMD ["bash", "-c", "source /etc/profile.d/dpdk-profile.sh && ls -l $RTE_SDK && echo 'DPDK installation verified' && exec bash"]
