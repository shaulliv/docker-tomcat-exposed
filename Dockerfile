FROM amazoncorretto:8-alpine3.15-jdk

MAINTAINER shaulliv

USER root
RUN mkdir /opt/tomcat
RUN apk add --no-cache tzdata
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz -P /tmp

ENV CATALINA_HOME /opt/tomcat
ENV CATALINA_BASE /opt/tomcat
ENV TZ Etc/Universal

COPY tomcat_init.sh /opt/startup/

EXPOSE 8080
VOLUME /opt/tomcat
ENTRYPOINT ["/opt/startup/tomcat_init.sh"]
