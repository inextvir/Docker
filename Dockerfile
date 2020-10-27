FROM ubuntu:14.04
MAINTAINER Inextvir team

ADD SURPI_setup.sh /

RUN chmod +x /SURPI_setup.sh
RUN /SURPI_setup.sh

CMD ["bash"]
