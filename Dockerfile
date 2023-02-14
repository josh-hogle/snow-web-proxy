#
# Dockerfile for ServiceNow proxy container
#
FROM httpd:2.4-alpine
SHELL ["/bin/sh", "-xeo", "pipefail", "-c"]

# Add files to image
COPY files /

# Configure image
RUN \
	ln -sf server.crt /usr/local/apache2/certs/snow.crt && \
	ln -sf server.pem /usr/local/apache2/certs/snow.pem && \
	chmod 0640 /usr/local/apache2/certs/server.pem && \
	chown -hR daemon:daemon /usr/local/apache2/certs

# Expose ports
EXPOSE 80
EXPOSE 443

# Required build arguments
ARG NAME
ARG VERSION
ARG RELEASE_DATE
ARG GIT_SHA1

# Image build metadata
ENV IMAGE_NAME "${NAME}"
ENV IMAGE_VERSION "${VERSION}"
ENV IMAGE_REVISION "${GIT_SHA1}"
ENV IMAGE_RELEASE_DATE "${RELEASE_DATE}"
LABEL \
	org.opencontainers.image.created="${RELEASE_DATE}" \
	org.opencontainers.image.authors="Josh Hogle <josh@joshhogle.com>" \
	org.opencontainers.image.url="https://github.com/josh-hogle/snow-web-proxy" \
	org.opencontainers.image.documentation="https://github.com/josh-hogle/snow-web-proxy" \
	org.opencontainers.image.source="https://github.com/josh-hogle/snow-web-proxy" \
	org.opencontainers.image.version="${VERSION}" \
	org.opencontainers.image.revision="${GIT_SHA1}" \
	org.opencontainers.image.vendor="Josh Hogle" \
	org.opencontainers.image.licenses="MIT" \
	org.opencontainers.image.title="Apache Web Proxy" \
	org.opencontainers.image.description="Apache server image to provide reverse proxy services to ServiceNow developer instances." \
	org.opencontainers.image.base.name="${NAME}:${GIT_SHA1}"
