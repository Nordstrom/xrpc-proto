## -*- docker-image-name: "nordstrom/java-protoc" -*-
## This is for an image for building Java protoc plugins.  The Java is needed for testing
## and the protobuf libraries are necessary to build the C++ based protoc plugin.
FROM debian:stretch
LABEL maintainer="Andy Day <andy.day@nordstrom.com>"

RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-8-jdk \
    ca-certificates-java \
    autoconf \
    automake \
    libtool \
    g++ \
    make \
    sudo \
    git \
    zip \
		bzip2 \
		unzip \
    ca-certificates \
		curl \
  && rm -fr /var/lib/apt/lists/* \
  && apt-get clean

RUN echo $JAVA_HOME
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

ENV LANG C.UTF-8

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
