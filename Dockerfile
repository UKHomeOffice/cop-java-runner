FROM docker.io/library/eclipse-temurin:18-jre

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
CMD ["/bin/bash"]
