FROM debian:latest
MAINTAINER Inextvir team

RUN git clone https://github.com/simonerampelli/viromescan.git

    && mv viromescan viromescan2
    && conda env create -f viromescan2/viromescan2.yml -p /your/conda/path/envs/viromescan
    && conda activate viromescan
    && wget https://sourceforge.net/projects/viromescan/files/viromescan.tar.gz 
    && tar -zxvf viromescan.tar.gz
    && rm -fr viromescan/tools/bmtagger.sh
    && cd viromescan2/viromescan_covid19/database/
    && unzip bowtie2.zip
    && cd -
    && mv viromescan2/viromescan_covid19/database/bowtie2/* viromescan/database/bowtie2/
    && mv viromescan2/viromescan_covid19/var/* viromescan/var/
    && chmod 777 viromescan2/viromescan_covid19/viromescan_covid19.sh
    && mv viromescan2/viromescan_covid19/viromescan_covid19.sh viromescan/
    && rm -fr viromescan2
    && cd viromescan/database

    && gzip -d Bacteria_custom/*.gz
    && gzip -d  bowtie2/*.gz
    && gzip -d hg19/*.gz

    && cd hg19/

    && bmtool -d hg19reference.fa -o hg19reference.bitmask -A 0 -w 18
    && srprism mkindex -i hg19reference.fa -o hg19reference.srprism -M 7168
    && makeblastdb -in hg19reference.fa -dbtype nucl

ENV PATH /opt/conda/bin:$PATH
