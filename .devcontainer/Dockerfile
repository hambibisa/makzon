# Dockerfile for Flutter environment in GitHub Codespaces
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools and dependencies for Flutter
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor once to download Dart SDK and other dependencies
RUN flutter doctor

# Enable web and desktop support
RUN flutter config --enable-web && flutter config --enable-linux-desktop

# Pre-download Flutter development binaries
RUN flutter precache
