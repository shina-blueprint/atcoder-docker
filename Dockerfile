FROM ubuntu:22.10

WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    g++-12 \
    libeigen3-dev=3.4.0-2ubuntu2 \
    libgmp3-dev \
    nodejs \
    npm \
    python3-pip \
    unzip \
    wget && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 50

RUN npm install -g atcoder-cli --no-cache && \
    acc config oj-path /usr/local/bin/oj && \
    acc config default-test-dirname-format test && \
    acc config default-task-choice all && \
    acc config default-template cpp

RUN pip install online-judge-tools --no-cache-dir

RUN wget https://github.com/atcoder/ac-library/releases/download/v1.5.1/ac-library.zip -O ac-library.zip && \
    unzip ac-library.zip -d /opt/ac-library && \
    rm ac-library.zip

RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.82.0/source/boost_1_82_0.tar.gz -O boost_1_82_0.tar.gz && \
    tar xf boost_1_82_0.tar.gz && \
    cd boost_1_82_0 && \
    ./bootstrap.sh --with-toolset=gcc --without-libraries=mpi,graph_parallel && \
    ./b2 -j3 toolset=gcc variant=release link=static runtime-link=static cxxflags="-std=c++20" stage && \
    ./b2 -j3 toolset=gcc variant=release link=static runtime-link=static cxxflags="-std=c++20" --prefix=/opt/boost/gcc install && \
    cd .. && \
    rm -rf boost_1_82_0 boost_1_82_0.tar.gz

ENV CPLUS_INCLUDE_PATH=/opt/boost/gcc/include:/opt/ac-library:/usr/include/eigen3
ENV LIBRARY_PATH=/opt/boost/gcc/lib

WORKDIR /

COPY cpp /root/.config/atcoder-cli-nodejs/cpp
