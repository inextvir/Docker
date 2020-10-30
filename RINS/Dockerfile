# template taken from https://hub.docker.com/r/continuumio/miniconda3/dockerfile
# Does not work yet
FROM ubuntu:14.04
MAINTAINER Inextvir team

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y gcc g++ make wget && \
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
    conda config --add channels default &&\
    conda install unzip

RUN mkdir /seq && \
    cd /seq && \
    wget -P /seq https://s3.amazonaws.com/changseq/kqu/rins/rins.tar.gz && \
    tar -xzvf /seq/rins.tar.gz -C /seq && \
    wget -P /seq http://hgdownload.soe.ucsc.edu/admin/jksrc.archive/jksrc.v341.zip && \
    unzip /seq/jksrc.v341.zip -d /seq

ENV PATH /seq:/opt/conda/bin:$PATH

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
    
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
