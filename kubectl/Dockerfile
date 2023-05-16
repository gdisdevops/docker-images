FROM alpine:latest

ARG KUBECTL_VERSION=1.25.8

USER root

RUN set -eux; \
    ARCH="$(uname -m)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
          wget "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl" && \
          echo "$(wget -O - "https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl.sha256")  kubectl" > kubectl.sha256 && \
          sha256sum -cw kubectl.sha256 && \
          install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
          rm kubectl \
         ;; \
       amd64|x86_64) \
          wget "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
          echo "$(wget -O - "https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256")  kubectl" > kubectl.sha256 && \
          sha256sum -cw kubectl.sha256 && \
          install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
          rm kubectl \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \

USER nobody
CMD ["/bin/sh"]
ENTRYPOINT []
