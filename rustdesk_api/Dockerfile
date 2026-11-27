ARG BUILD_FROM=lejianwen/rustdesk-server-s6:latest
FROM ${BUILD_FROM}

# Install jq so our entrypoint can read Home Assistant's options.json
RUN apk add --no-cache jq || (apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*)

COPY run.sh /
RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]