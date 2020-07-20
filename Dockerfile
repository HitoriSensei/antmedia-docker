FROM ubuntu:18.04

ARG MongoDBServer=
ARG MongoDBUsername=
ARG MongoDBPassword=

RUN apt-get update
RUN apt-get install -y libcap2 wget net-tools

RUN cd home \
    && pwd \
    && wget https://github.com/ant-media/Ant-Media-Server/releases/download/ams-v2.0.0/ant-media-server-2.0.0-community-2.0.0-20200504_1842.zip

ARG AntMediaServer=ant-media-server-2.0.0-community-2.0.0-20200504_1842.zip

RUN cd home \
    && pwd \
    && wget https://raw.githubusercontent.com/ant-media/Scripts/master/install_ant-media-server.sh \
    && chmod 755 install_ant-media-server.sh

RUN cd home \
    && pwd \
    && ./install_ant-media-server.sh ${AntMediaServer}


RUN /bin/bash -c 'if [ ! -z "${MongoDBServer}" ]; then \
                    /usr/local/antmedia/change_server_mode.sh cluster ${MongoDBServer} ${MongoDBUsername} ${MongoDBPassword}; \
                 fi'

RUN apt-get remove openjdk-11* -y                 
                 
WORKDIR /usr/local/antmedia

ENTRYPOINT ./start.sh
