# build the epubcheck.jar file
FROM maven:3-eclipse-temurin-21-alpine AS builder

WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests

# prepare runner for epubcheck.jar execution
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=builder /app .
RUN echo '#!/bin/bash\n java -jar /app/target/epubcheck.jar "${@:1}"\n' > entrypoint.sh
RUN chmod +x entrypoint.sh

ENV DATA_PATH=/data
WORKDIR ${DATA_PATH}
VOLUME ${DATA_PATH}

ENTRYPOINT [ "/app/entrypoint.sh" ]
