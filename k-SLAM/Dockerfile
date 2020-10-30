# template taken from https://hub.docker.com/r/continuumio/miniconda3/dockerfile
# Does not work yet
FROM debian:latest
MAINTAINER Inextvir team

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y gcc make build-essential && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
    
RUN conda config --add channels conda-forge && \
    conda config --add channels bioconda && \
    conda config --add channels default 

RUN mkdir /work && \
    git clone https://github.com/aindj/k-SLAM /work/k-slam && \
    wget -P /work/ https://sourceforge.net/projects/boost/files/boost/1.63.0/boost_1_63_0.tar.gz && \
    tar -xzvf /work/boost_1_63_0.tar.gz -C /work/ && \
    cd /work/boost_1_63_0 && \
    ./bootstrap.sh && \
    ./b2 install && \
    cd /work/k-slam/build/ && \
    make && \
    mv build/SLAM ./

ENV PATH /work/k-slam:$PATH
ENV LD_LIBRARY_PATH /usr/local/lib/:$LD_LIBRARY_PATH

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
    
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
