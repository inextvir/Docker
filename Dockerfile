FROM debian:latest
MAINTAINER Inextvir team

RUN git clone -b docker https://<token>:x-oauth-basic@github.com/sejmodha/MetaViC.git /metavic/
