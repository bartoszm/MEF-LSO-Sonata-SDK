FROM maven:3.6.3-jdk-8 as build
RUN apt update && apt install -y git

RUN git clone https://github.com/bartoszm/codegen-wrapper.git
RUN cd codegen-wrapper && mvn package

FROM openjdk:8u242-jre-buster
WORKDIR /opt/MEF
COPY --from=build /codegen-wrapper/configurations ./configurations
COPY --from=build /codegen-wrapper/target/codegen-wrapper-1.0.jar ./wrapper.jar
COPY api api
COPY payload_descriptions payload_descriptions

ENTRYPOINT ["java", "-jar", "wrapper.jar"]