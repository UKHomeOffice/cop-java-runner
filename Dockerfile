ARG JAVA_VERSION

FROM docker.io/library/eclipse-temurin:${JAVA_VERSION} as jlink-build

RUN ${JAVA_HOME}/bin/jlink \
        --add-modules ALL-MODULE-PATH \
        --compress=2 \
        --no-header-files \
        --no-man-pages \
        --strip-debug \
        --output /javaruntime


FROM docker.io/library/ubuntu:latest

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"

COPY --from=jlink-build /javaruntime "${JAVA_HOME}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    find /var/lib/apt/lists -type f -print0 | xargs --null rm -f && \
    find /var/cache/apt -type f -print0 | xargs --null rm -f

RUN addgroup --gid 1000 java && \
    adduser --uid 1000 --gid 1000 --gecos "Java User" --home /home/java \
            --shell /usr/sbin/nologin --disabled-password java && \
    mkdir /app && \
    chown -R java:java /app

USER java
WORKDIR /app
ENTRYPOINT ["/bin/bash"]
