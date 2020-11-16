FROM continuumio/miniconda3

RUN apt update && apt install -y procps make gcc && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN conda install -c bioconda blast
