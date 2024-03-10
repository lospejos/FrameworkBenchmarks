FROM maven:3.9.6-eclipse-temurin-21-jammy
WORKDIR /jooby
COPY pom.xml pom.xml
COPY src src
COPY public public
COPY conf conf

RUN mvn package -q -P undertow

FROM ghcr.io/graalvm/native-image-community:21 AS build_native
COPY ./target/jooby.jar /build/app.jar
#COPY --from=build_jar jooby-rest-example-1.0.0.jar /build/app.jar
#RUN gu install native-image
#COPY app.jar /build/
RUN cd /build && native-image --static -jar ./app.jar -o output
#-H:Name=output

FROM scratch
COPY --from=build_native /build/output /opt/app
EXPOSE 8080
CMD ["/opt/app"]
# CMD ["java", "-server", "-Xms2g", "-Xmx2g", "-XX:+UseNUMA", "-XX:+UseParallelGC", "-jar", "target/jooby.jar"]
