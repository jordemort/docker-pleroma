FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates curl dumb-init ffmpeg imagemagick libimage-exiftool-perl libmagic-dev libncurses5 unzip && \
    apt-get clean

# Set the flavour environment variable to the string you got in Detecting flavour section.
# For example if the flavour is `amd64-musl` the command will be
ENV FLAVOUR=amd64

RUN mkdir -p /var/lib/pleroma/uploads /var/lib/pleroma/static /etc/pleroma && \
    adduser --system --shell /bin/false --home /opt/pleroma pleroma && \
    chown -R pleroma /var/lib/pleroma /etc/pleroma

USER pleroma

# Clone the release build into a temporary directory and unpack it
RUN curl "https://git.pleroma.social/api/v4/projects/2/jobs/artifacts/stable/download?job=$FLAVOUR" -o /tmp/pleroma.zip && \
    unzip /tmp/pleroma.zip -d /tmp/ && \
    mv /tmp/release/* /opt/pleroma && \
    rmdir /tmp/release && \
    rm /tmp/pleroma.zip
