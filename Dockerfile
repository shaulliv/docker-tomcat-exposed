FROM amazoncorretto:8-alpine3.15-jdk

MAINTAINER shaulliv

USER root
RUN mkdir /opt/tomcat
RUN apk add --no-cache tzdata
RUN apk add --no-cache curl
RUN apk add --no-cache grep
RUN apk add --no-cache head
RUN tcatver=$(curl https://dlcdn.apache.org/tomcat/tomcat-9/ | grep -m 1 -o 9.0.* | head -c 6)
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v"$tcatver"/bin/apache-tomcat-"$tcatver".tar.gz -P /tmp

ENV CATALINA_HOME /opt/tomcat
ENV CATALINA_BASE /opt/tomcat
ENV TZ Etc/Universal

COPY tomcat_init.sh /opt/startup/

EXPOSE 8080
VOLUME /opt/tomcat
ENTRYPOINT ["/opt/startup/tomcat_init.sh"]
