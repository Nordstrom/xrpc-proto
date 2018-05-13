## -*- docker-image-name: "nordstrom/java-protoc" -*-
## This is for an image for building Java protoc plugins.  The Java is needed for testing
## and the protobuf libraries are necessary to build the C++ based protoc plugin.
FROM debian:stretch
LABEL maintainer="Andy Day <andy.day@nordstrom.com>"

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

# ENV JAVA_VERSION 8u162
# ENV JAVA_DEBIAN_VERSION 8u162-b12-1~deb9u1

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
# ENV CA_CERTIFICATES_JAVA_VERSION 20170531+nmu1

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
# RUN { \
# 		echo '#!/bin/sh'; \
# 		echo 'set -e'; \
# 		echo; \
# 		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
# 	} > /usr/local/bin/docker-java-home \
# 	&& chmod +x /usr/local/bin/docker-java-home


# RUN set -ex; \
	# \
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	# if [ ! -d /usr/share/man/man1 ]; then \
		# mkdir -p /usr/share/man/man1; \
	# fi; \
	# \
	# apt-get update && apt-get install -y \
		# openjdk-8-jdk \
	# 	ca-certificates-java \
	# && \
	# rm -rf /var/lib/apt/lists/* && \
	# \
# verify that "docker-java-home" returns what we expect
	# \
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	# update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	# update-alternatives --query java | grep -q 'Status: manual'


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

# RUN [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]

RUN echo $JAVA_HOME
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Default to UTF-8 file.encoding
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
