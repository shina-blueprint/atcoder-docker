FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt-get update \
    && apt-get install -y --no-install-recommends g++-9 git nodejs npm python3-pip python3.8 time \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 10 \
    && pip3 install --no-cache-dir online-judge-tools \
    && npm install -g atcoder-cli \
    && npm cache clean --force \
    && acc config oj-path /usr/local/bin/oj \
    && acc config default-test-dirname-format test \
    && acc config default-task-choice all \
    && acc config default-template cpp \
    && git clone https://github.com/atcoder/ac-library.git /opt/ac-library

COPY cpp /root/.config/atcoder-cli-nodejs/cpp

ENV CPLUS_INCLUDE_PATH /opt/ac-library
