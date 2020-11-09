#!/bin/bash
#
#	METAVIC_setup.sh
#
#	This script will install SURPI and its dependencies.
#	The script has been designed to work on a newly installed OS, though should also work on an existing system.
#

export DEBIAN_FRONTEND=noninteractive
chmod 777 /root

apt-get update
apt-get install -y apt-utils git unzip wget curl csh gawk cpanminus gdb gcc g++ build-essential autoconf automake libtool
apt-get install -y python-pip aptitude expat libexpat1-dev libz-dev libboost-all-dev qt4-default pkg-config libgd-dev



#
##
###
####
#####
######
####### Conda available dependencies : bowtie2, diamond, idba, krona, quast, spades, trim-galore
######
#####
####
###
##
#

conda install -y -c bioconda bowtie2
conda install -y -c bioconda diamond
conda install -y -c bioconda idba
conda install -y -c bioconda krona #ktImportTaxonomy
conda install -y -c conda-forge -c bioconda quast
conda install -y -c bioconda spades #spades.py
conda install -y -c bioconda trim-galore #trim_galore



#
##
###
####
#####
######
####### Perl scripts
######
#####
####
###
##
#

## filter_fastq.pl
wget --directory-prefix=/usr/local/bin https://raw.githubusercontent.com/lmrodriguezr/enveomics/master/Scripts/FastQ.filter.pl
chmod +x /usr/local/bin/FastQ.filter.pl
#FastQ.filter.pl


## prinseq lite  https://vcru.wisc.edu/simonlab/bioinformatics/programs/install/prinseq.htm
cpanm Getopt::Long Pod::Usage File::Temp Fcntl Digest::MD5 Cwd List::Util
wget http://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz
tar -zxvf prinseq-lite-0.20.4.tar.gz
cp -puv prinseq-lite-0.20.4/prinseq-lite.pl /usr/local/bin/prinseq-lite && chmod +x /usr/local/bin/prinseq-lite
rm /prinseq-lite-0.20.4.tar.gz
#prinseq-lite -h


#
##
###
####
#####
######
####### riboPicker	https://sourceforge.net/projects/ribopicker/files/
######
#####
####
###
##
#
cpanm Data::Dumper Getopt::Long Pod::Usage File::Path FindBin
wget --directory-prefix=/usr/local/bin https://sourceforge.net/projects/ribopicker/files/standalone/ribopicker-standalone-0.4.3.tar.gz
cd /usr/local/bin
tar -xvzf /usr/local/bin/ribopicker-standalone-0.4.3.tar.gz
cp -puv /usr/local/bin/ribopicker-standalone-0.4.3/ribopicker.pl /usr/local/bin/ribopicker && chmod +x /usr/local/bin/ribopicker
cp -puv /usr/local/bin/ribopicker-standalone-0.4.3/riboPickerConfig.pm /usr/local/bin/
rm /usr/local/bin/ribopicker-standalone-0.4.3.tar.gz
#ribopicker -h


#
##
###
####
#####
######
####### weeSAMv1.1	https://github.com/josephhughes/Sequence-manipulation/blob/master/weeSAMv1.1
######
#####
####
###
##
#

#
#
## Install libpng-1.6.2
#
#
wget http://downloads.sourceforge.net/project/libpng/libpng16/older-releases/1.6.2/libpng-1.6.2.tar.gz
tar -xvf libpng-1.6.2.tar.gz
cd /libpng-1.6.2
./configure --prefix=`pwd`
make
make install
LIBPNGDIR=`pwd`
cd ..
rm libpng-1.6.2.tar.gz
#
#
## R
#
#
apt-get install -y dirmngr --install-recommends
apt-get install -y software-properties-common
apt-get install -y apt-transport-https
apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian buster-cran35/'
apt-get update
apt install -y r-base
#
cpanm CGI GD::Graph::lines Statistics::R Parallel::ForkManager List::MoreUtils
wget --directory-prefix=/usr/local/bin https://raw.githubusercontent.com/josephhughes/Sequence-manipulation/master/weeSAMv1.1
chmod +x /usr/local/bin/weeSAMv1.1
#weeSAMv1.1


#
##
###
####
#####
######
####### GARM https://sourceforge.net/projects/garm-meta-assem/files/
######
#####
####
###
##
#

wget --directory-prefix=/usr/local/bin https://sourceforge.net/projects/garm-meta-assem/files/GARM_v0.7.5.tar.gz
cd /usr/local/bin
tar -xvzf GARM_v0.7.5.tar.gz
sed -i '13i\use lib "/usr/local/bin/GARM_v0.7.5/lib/";' /usr/local/bin/GARM_v0.7.5/GARM.pl
chmod +x /usr/local/bin/GARM_v0.7.5/GARM.pl

echo "GARMBIN=/usr/local/bin/GARM_v0.7.5/bin" >> ~/.bashrc
echo "GARMLIB=/usr/local/bin/GARM_v0.7.5/lib" >> ~/.bashrc
echo "MUMBIN=/usr/local/bin/GARM_v0.7.5/MUMmer3.22" >> ~/.bashrc
echo "AMOSBIN=/usr/local/bin/GARM_v0.7.5/amos-3.0.0/bin" >> ~/.bashrc
echo "AMOSLIB=/usr/local/bin/GARM_v0.7.5/amos-3.0.0/lib" >> ~/.bashrc

export PATH=$PATH:$GARMBIN:$GARMLIB:$MUMBIN:$AMOSBIN:$AMOSLIB
export GARMBIN=/free/programs/garm/GARM_v0.7.5/bin
export GARMLIB=/free/programs/garm/GARM_v0.7.5/lib
export MUMBIN=/free/programs/garm/GARM_v0.7.4/MUMmer3.22
export AMOSBIN=/free/programs/garm/GARM_v0.7.4/amos-3.0.0/bin

echo "PATH=$PATH:$GARMBIN:$GARMLIB:$MUMBIN:$AMOSBIN:$AMOSLIB" >> ~/.bashrc
echo "PATH=$PATH:/usr/local/bin/GARM_v0.7.5" >> ~/.bashrc

rm GARM_v0.7.5.tar.gz
cd ~
#GARM.pl -h


#
##
###
####
#####
######
####### MetaViC
######
#####
####
###
##
#
cd /usr/local/bin
git clone https://github.com/sejmodha/MetaViC.git
echo "PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/bin/MetaViC" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/bin/ribopicker-standalone-0.4.3/" >> ~/.bashrc

. ~/.bashrc
#Cleaning.sh
#Assemble.sh
