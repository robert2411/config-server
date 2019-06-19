FROM debian:stable AS parent_downloader
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && apt-get install -qy libxml2-utils
RUN apt-get update -q && apt-get install -qy curl

COPY ./pom.xml /project/pom.xml
RUN export VERSION=$(xmllint --xpath "//*[local-name()='project']/*[local-name()='parent']/*[local-name()='version']/text()" /project/pom.xml) \
&& echo "version: ${VERSION}" \
&& curl -LJO https://raw.githubusercontent.com/robert2411/parent-pom/${VERSION}/pom.xml

FROM maven:3-jdk-11 AS builder
COPY --from=parent_downloader /pom.xml /parent/pom.xml
WORKDIR /parent
RUN mvn clean install

WORKDIR /project
COPY ./pom.xml /project/pom.xml
RUN mvn dependency:resolve
COPY . /project
RUN mvn clean package

FROM gcr.io/distroless/java:11 AS config-server
COPY --from=builder /project/target/config-server.jar /app/config-server.jar
WORKDIR /app
CMD ["config-server.jar"]

