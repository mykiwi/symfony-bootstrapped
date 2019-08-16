ARG BASE_ALPINE_IMAGE=nginx:1-alpine

FROM $BASE_ALPINE_IMAGE

RUN set -xe \
 && apk add --no-cache \
      openssl \
 && openssl genrsa \
      -des3 \
      -passout pass:NotSecure \
      -out cert.pass.key \
      2048 \
 && openssl rsa \
      -passin pass:NotSecure \
      -in cert.pass.key \
      -out cert.key \
 && openssl req \
      -new \
      -passout pass:NotSecure \
      -key cert.key \
      -out cert.csr \
      -subj '/C=SS/ST=SS/L=The Internet/O=Symfony/CN=client' \
 && openssl x509 \
      -req \
      -sha256 \
      -days 365 \
      -in cert.csr \
      -signkey cert.key \
      -out cert.crt

FROM $BASE_ALPINE_IMAGE

COPY --from=0 cert.key cert.crt /etc/nginx/ssl/
COPY conf.d /etc/nginx/conf.d/
