## -*- docker-image-name: "nordstrom/java-protoc" -*-
## This is for an image for building Java protoc plugins.  The Java is needed for testing
## and the protobuf libraries are necessary to build the C++ based protoc plugin.
FROM openjdk:8-jdk
MAINTAINER Andy Day <andy.day@nordstrom.com>

RUN apt-get update \
  && apt-get install -y autoconf libtool g++ make sudo zip \
  && rm -fr /var/lib/apt/lists/* \
  && apt-get clean

RUN git clone https://github.com/google/protobuf.git \
  && cd protobuf \
  && git checkout v3.5.1 \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make check \
  && sudo make install

RUN curl -LO https://services.gradle.org/distributions/gradle-4.7-bin.zip \
  && sudo mkdir /opt/gradle \
  && sudo unzip -d /opt/gradle gradle-4.7-bin.zip

ENV PATH $PATH:/opt/gradle/gradle-4.7/bin
RUN gradle -v
