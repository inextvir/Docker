# template taken from https://hub.docker.com/r/continuumio/miniconda3/dockerfile
# Does not work yet
FROM debian:latest
MAINTAINER Inextvir team

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /work/:/opt/conda/bin:$PATH

RUN echo "deb http://ftp.us.debian.org/debian unstable main contrib non-free" > /etc/apt/sources.list.d/unstable.list && \
    apt-get update --fix-missing && \
    apt-get install -y gcc-4.8 g++-4.8 gcc-4.8-multilib make build-essential && \
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
    git clone https://github.com/EBI-COMMUNITY/fli-RIEMS /work/RIEMS && \
    wget -P /work ftp://emboss.open-bio.org/pub/EMBOSS/old/6.3.1/EMBOSS-6.3.1.tar.gz && \
    tar -xzvf /work/EMBOSS-6.3.1.tar.gz -O -P /work && \
    cd /work/EMBOSS-6.3.1 && ./configure --without-x && make && make install && \
    wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.4.0/ncbi-blast-2.4.0+-src.tar.gz -P /work && \
    tar -xzvf ncbi-blast-2.4.0+-src.tar.gz -C /work/ 

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
    
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
