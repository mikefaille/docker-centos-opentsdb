FROM mikefaille/centos-hbase:latest
MAINTAINER michael@faille.io <michael@faille.io>

ENV COMPRESSION gz

#Warning. Dont touch this. cant be a variable on git clone destination..
ENV OPENTSDB_DIR /tsdb

#OPENTSDB
#For compatibility purpose
ENV TSDB $OPENTSDB_DIR
#RUN yum install https://github.com/OpenTSDB/opentsdb/releases/download/v2.1.0/opentsdb-2.1.0.noarch.rpm -y; yum clean all


# Opentsdb foundation
RUN git clone --single-branch --depth 1 git://github.com/OpenTSDB/opentsdb.git /tsdb && \
    cd $TSDB && yum install autoconf automake sysconftool.noarch java-1.8.0-openjdk-devel make -y && bash ./build.sh && \
    yum remove  autoconf automake sysconftool.noarch java-1.8.0-openjdk-devel  -y && yum autoremove -y && yum clean all
ADD conf/opentsdb.conf $TSDB/opentsdb.conf
EXPOSE 4242


# Supervisor
ADD conf/supervisor-opentsdb.ini /etc/supervisord.d/opentsdb.ini

# Insert startup files
ADD conf/create_table.sh /data/create_table.sh
ADD conf/create_tsdb_tables.sh /data/create_tsdb_tables.sh
ADD conf/start-opentsdb.sh /data/start-opentsdb.sh
