# template taken from https://hub.docker.com/r/continuumio/miniconda3/dockerfile
FROM debian:latest
MAINTAINER Inextvir team

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /work:/opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y gcc make build-essential && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3 \
    && conda update conda \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes
    
RUN conda config --add channels conda-forge && \
    conda config --add channels bioconda && \
    conda config --add channels default && \
    conda config --add channels menpo

RUN conda create -n py27 python=2.7 numpy argparse keras scikit-learn pandas enum && conda clean -a

RUN mkdir /work && \
    git clone https://github.com/NeuroCSUT/ViraMiner /work/viraminer

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
    
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
