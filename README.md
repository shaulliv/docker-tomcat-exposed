# docker-tomcat-exposed
An Docker image the is designed to expose all of the Tomcat file structure to the host OS
### Image info
The image is designed to expose the entire tomcat folder structure for development purposes running under root user.<br>
After deploying the image the tomcat_init script will run and either deploy version 9.0.78 of tomcat if the directory is empty or run tomcat.
before every run of tomcat the script makes sure the the directory structure is owned by user `tomcat` and belongs to group `tomcat`.
#### Parameters
-p 8080 - Tomcat port<br>
-e TZ=Etc/Universal - Timezone<br>
-v /opt/tomcat - the location where tomcat is installed<br>

#### How to change Java or tomcat versions
To build an image with different versions of Java or Tomcat change the following parameters in the **Dockerfile:**<br>
`FROM amazoncorretto:8-alpine3.15-jdk` can be changed to any image in the list [here](https://hub.docker.com/_/amazoncorretto).

`RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.78/bin/apache-tomcat-9.0.78.tar.gz -P /tmp` the tomcat file can be changed to any `tar.gz` file containing romcat available [here](https://dlcdn.apache.org/tomcat/), this usually is under the `bin` directory of any specific version.
## Usage
### Building the image
The image needs to be built it is **not** deployed to dockerhub.
Here are the instruction to build the image:
```bash
git clone https://github.com/shaulliv/docker-tomcat-exposed.git

docker build -t tomcat-exposed:latest docker-tomcat-exposed/
```
### Deploying the Image
#### CLI
```bash
docker run -d \
  --name=tomcat \
  -e TZ=Etc/UTC \
  -p 8080:8080 \
  -v /path/to/tomcat:/opt/tomcat \
  --restart unless-stopped \
  tomcat-exposed:latest
```

#### docker-compose
```yaml
version: "2.1"
services:
  emby:
    image: tomcat-exposed:latest
    container_name: tomcat
    environment:
      - TZ=Etc/UTC
    volumes:
      - /path/to/tomcat:/opt/tomcat 
    ports:
      - 8080:8080
    restart: unless-stopped
```
