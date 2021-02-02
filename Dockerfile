FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl dumb-init ffmpeg gnupg imagemagick libimage-exiftool-perl libmagic-dev libncurses5 locales unzip && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/postgres.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client-13 && \
    apt-get clean

RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /var/lib/pleroma/uploads /var/lib/pleroma/static /etc/pleroma && \
    adduser --system --shell /bin/false --home /opt/pleroma pleroma && \
    chown -R pleroma /var/lib/pleroma /etc/pleroma

VOLUME [ "/etc/pleroma", "/var/lib/pleroma/uploads", "/var/lib/pleroma/static" ]

USER pleroma

# Set the flavour environment variable to the string you got in Detecting flavour section.
# For example if the flavour is `amd64-musl` the command will be
ENV FLAVOUR=amd64

# Clone the release build into a temporary directory and unpack it
RUN curl "https://git.pleroma.social/api/v4/projects/2/jobs/artifacts/stable/download?job=$FLAVOUR" -o /tmp/pleroma.zip && \
    unzip /tmp/pleroma.zip -d /tmp/ && \
    mv /tmp/release/* /opt/pleroma && \
    rmdir /tmp/release && \
    rm /tmp/pleroma.zip && \
    mkdir -p /opt/pleroma/bin

COPY *.sh /opt/pleroma/bin/

ENTRYPOINT [ "/usr/bin/dumb-init" ]

WORKDIR /opt/pleroma

ENV PATH=/opt/pleroma/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PLEROMA_CONFIG_PATH=/etc/pleroma/config.exs

EXPOSE 4000

STOPSIGNAL SIGTERM

HEALTHCHECK \
    --start-period=10m \
    --interval=5m \
    CMD curl --fail http://localhost:4000/api/v1/instance || exit 1

CMD [ "run-pleroma.sh" ]
