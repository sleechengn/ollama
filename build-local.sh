#!/usr/bin/bash
set -e

pushd $(dirname $0)/.source
rm -rf ollama-linux-amd64.tgz*
aria2c -x 10 -j 10 -k 1M "https://github.com/ollama/ollama/releases/download/v0.6.7-rc2/ollama-linux-amd64.tgz" -o "ollama-linux-amd64.tgz"
popd

mkdir -p /opt/tmp
rm -rf /opt/tmp/ollama-build
cp -r . /opt/tmp/ollama-build
pushd /opt/tmp/ollama-build

sed -i '1i\# syntax=docker/dockerfile:1.3' Dockerfile

sed -i "/^#APT-PLACE-HOLDER.*/i\RUN apt update" Dockerfile
sed -i "/^#APT-PLACE-HOLDER.*/i\RUN apt install -y ca-certificates" Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN mv /etc/apt/sources.list /etc/apt/sources.list.back' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT-PLACE-HOLDER.*/i\RUN apt update' Dockerfile

sed -i '/.*echo\sinstall\ssource.*/d' Dockerfile
sed -i '/^#INSTALL-OLLAMA.*/i\run --mount=type=bind,target=/root/.source,rw,source=.source set -e && mkdir -p /opt/ollama && cp /root/.source/ollama-linux-amd64.tgz /opt/ollama && cd /opt/ollama && tar -zxvf ollama-linux-amd64.tgz && rm -rf ollama-linux-amd64.tgz && ln -s /opt/ollama/bin/ollama /usr/bin/ollama' Dockerfile

./build.sh 192.168.13.73:5000/sleechengn/ollama:latest
docker push 192.168.13.73:5000/sleechengn/ollama:latest

popd
