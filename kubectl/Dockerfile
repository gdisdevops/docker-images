FROM alpine:latest

ARG KUBECTL_VERSION=1.25.8
USER root

RUN wget "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
  echo "$(wget -O - "https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256")  kubectl" > kubectl.sha256 && \
  sha256sum -cw kubectl.sha256 && \
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
  rm kubectl

USER nobody
CMD ["/bin/sh"]
ENTRYPOINT []
