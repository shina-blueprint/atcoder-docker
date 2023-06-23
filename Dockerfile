FROM ubuntu:18.04

ENV CPLUS_INCLUDE_PATH /usr/include/python3.8:/opt/boost/gcc/include:/opt/ac-library
ENV LIBRARY_PATH /opt/boost/gcc/lib

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y --no-install-recommends g++-9 git nodejs npm python3-pip python3.8 python3.8-dev time wget\
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 10 \
    && python3.8 -m pip install --no-cache-dir online-judge-tools \
    && npm install -g atcoder-cli \
    && npm cache clean --force \
    && acc config oj-path /usr/local/bin/oj \
    && acc config default-test-dirname-format test \
    && acc config default-task-choice all \
    && acc config default-template cpp \
    && git clone https://github.com/atcoder/ac-library.git /opt/ac-library \
    && wget https://boostorg.jfrog.io/artifactory/main/release/1.72.0/source/boost_1_72_0.tar.bz2 \
    && tar xf boost_1_72_0.tar.bz2 \
    && rm boost_1_72_0.tar.bz2

WORKDIR /boost_1_72_0
RUN ./bootstrap.sh --with-toolset=gcc --without-libraries=mpi,graph_parallel \
    && ./b2 -j3 toolset=gcc variant=release link=static runtime-link=static cxxflags=""-std=c++17"" stage \
    && ./b2 -j3 toolset=gcc variant=release link=static runtime-link=static cxxflags=""-std=c++17"" --prefix=/opt/boost/gcc install

WORKDIR /
COPY cpp /root/.config/atcoder-cli-nodejs/cpp
