FROM ubuntu:18.04 as builder

ARG KUBERNETES_VERSION=v1.15.7

ADD https://dl.k8s.io/${KUBERNETES_VERSION}/kubernetes-client-linux-amd64.tar.gz /kubectl.tar.gz
RUN tar -zxvf /kubectl.tar.gz

FROM scratch

COPY --from=builder /kubernetes/client/bin/kubectl /kubectl
ENTRYPOINT ["/kubectl"]
