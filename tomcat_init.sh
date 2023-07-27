#!/bin/sh
DIR="/opt/tomcat"
# init
# look for empty dir
if [ -d "$DIR" ]
then
	if [ "$(ls -A $DIR)" ]; then
     # if /opt/tomcat is full
	 chown -R tomcat:tomcat /opt/tomcat/* && \
	 /bin/sh /opt/tomcat/bin/catalina.sh run
	else
	 # if /opt/tomcat is epmty
     echo "/opt/tomcat is empty"
	 cd /tmp && \
     tar xvf apache-tomcat-*.tar.gz -C /opt/tomcat --strip-components=1 && \
     addgroup tomcat && \
     adduser -D -H -s /bin/nologin -G tomcat -h /opt/tomcat tomcat && \
	 #set up permissions
	 chmod -R g+r /opt/tomcat/conf && \
     chmod -R g+x /opt/tomcat/conf && \
     chmod -R g+w /opt/tomcat && \
     chown -R tomcat:tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
	 # first run to deploy webapps
	 /bin/sh /opt/tomcat/bin/catalina.sh run & \
	 sleep 10
	 until [ "$(tail /opt/tomcat/logs/catalina.*.log | grep 'Server startup in')" ];
	 do
		echo "sleeping 10 seconds"
		sleep 10
	 done
	 /bin/sh /opt/tomcat/bin/catalina.sh stop && \
	 # setup of access to manager apps
	 sed -i 's/<Valve/<!--<Valve/g' /opt/tomcat/webapps/manager/META-INF/context.xml && \
	 sed -i 's/1" \/>/1" \/>-->/g' /opt/tomcat/webapps/manager/META-INF/context.xml && \
	 sed -i 's/<Valve/<!--<Valve/g' /opt/tomcat/webapps/host-manager/META-INF/context.xml && \
	 sed -i 's/1" \/>/1" \/>-->/g' /opt/tomcat/webapps/host-manager/META-INF/context.xml && \
	 # cleanup of /tmp
	 rm -rf /tmp/* && \
	 #run tomcat after install
	 chown -R tomcat:tomcat /opt/tomcat/* && \
	 /bin/sh /opt/tomcat/bin/catalina.sh run
	fi
else
	echo "/opt/tomcat not found or another problem occured"
fi
