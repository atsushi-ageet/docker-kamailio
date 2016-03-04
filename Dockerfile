FROM ubuntu:14.04

RUN echo 'deb http://deb.kamailio.org/kamailio trusty main\n\
deb-src http://deb.kamailio.org/kamailio trusty main\n'\
>> /etc/apt/sources.list

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xfb40d3e6508ea4c8
RUN apt-get update && apt-get -y upgrade && apt-get -y install kamailio

CMD kamailio -DD
