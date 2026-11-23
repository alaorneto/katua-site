# Site institucional da Katuá Tech servido pelo nginx, sem root, na porta 8080.
# A base é a versão estável do nginx (linha par), fixada por digest; atualize tag e digest juntos.
FROM nginxinc/nginx-unprivileged:1.30.6-alpine@sha256:f5116ed4606f3eb015dd4a8e28cb9b351476dc0ad4bc6e9f93b19cec130cdf03

ARG VERSION=dev
ARG REVISION=unknown

LABEL org.opencontainers.image.title="katua-site" \
      org.opencontainers.image.description="Site institucional da Katuá Tech" \
      org.opencontainers.image.vendor="Katuá Tech" \
      org.opencontainers.image.source="https://github.com/alaorneto/katua-site" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${REVISION}"

# Configuração do servidor: substitui o default.conf da imagem base.
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY docker/security-headers.conf /etc/nginx/snippets/security-headers.conf

# O site, numa pasta própria (a base traz index.html e 50x.html de exemplo em /usr/share/nginx/html).
# Só COPY sobre a base: o build para amd64 e arm64 não precisa de emulação.
COPY index.html 404.html /usr/share/nginx/site/
COPY assets /usr/share/nginx/site/assets

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1
