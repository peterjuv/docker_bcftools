FROM ubuntu:latest

ENV BCFTOOLS_VERSION=1.21
ENV BCFTOOLS_INSTALL_DIR=/opt/bcftools
ENV PYTHON_VERSION=3.12

LABEL \
  description="bcftools image for workflows" \
  version=$BCFTOOLS_VERSION \
  maintainer="Peter Juvan <peter.juvan@gmail.com>, adapted from Thomas B. Mooney <tmooney@genome.wustl.edu>"

RUN apt-get update && apt-get install -y \
  bzip2 \
  g++ \
  libbz2-dev \
  libcurl4-openssl-dev \
  liblzma-dev \
  make \
  ncurses-dev \
  wget \
  zlib1g-dev \
  python3 \
  python3-pip

WORKDIR /tmp
RUN \
  wget https://github.com/samtools/bcftools/releases/download/$BCFTOOLS_VERSION/bcftools-$BCFTOOLS_VERSION.tar.bz2 && \
  tar --bzip2 -xf bcftools-$BCFTOOLS_VERSION.tar.bz2

WORKDIR /tmp/bcftools-$BCFTOOLS_VERSION
RUN \
  make prefix=$BCFTOOLS_INSTALL_DIR && \
  make prefix=$BCFTOOLS_INSTALL_DIR install

WORKDIR /
RUN \
  ln -s $BCFTOOLS_INSTALL_DIR/bin/bcftools /usr/bin/bcftools && \
  rm -rf /tmp/bcftools-$BCFTOOLS_VERSION

RUN \
  mv /usr/lib/python$PYTHON_VERSION/EXTERNALLY-MANAGED /usr/lib/python$PYTHON_VERSION/EXTERNALLY-MANAGED.old
RUN \
  pip3 install biopython pandas

#ENTRYPOINT ["/usr/bin/bcftools"]
