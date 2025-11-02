FROM jenkins/inbound-agent:alpine-jdk21

USER root

ARG VAULT_VERSION=1.20.4
ARG PACKER_VERSION=1.14.2
ARG TERRAFORM_1_VERSION=1.13.3
ARG KUBECTL_VERSION=1.31.8
ARG HELM_VERSION=v3.19.0
ARG ANSIBLE_VERSION=11.11.0
ARG INFRACOST_VERSION=v0.10.40
ARG COSIGN_VERSION=2.6.1
ARG SENTRY_CLI_VERSION=2.56.1
ARG CHECKOV_VERSION=3.2.477
ARG VAULT_CRD_RENDERER_VERSION=1.0.7
ARG PIP_HVAC_VERSION=2.4.0
ARG KYVERNO_CLI_VERSION=v1.14.2

ENV PIP_BREAK_SYSTEM_PACKAGES=1

ENV NIXPKGS_ALLOW_UNFREE=1

RUN mkdir -p /etc/nix && echo "sandbox = false" >> /etc/nix/nix.conf
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf

RUN set -eux; \
  apk update && \
  apk add --no-cache \
  curl \
  ca-certificates \
  gnupg \
  openssh \
  git \
  unzip \
  tar \
  libffi-dev \
  jq \
  yq \
  xxd \
  xz \
  python3 \
  py3-pip \
  aws-cli \
  gcompat \
  bash \
  findutils \
  coreutils \
  nix; \
  # Optional: Add PostgreSQL client if available in Alpine repos
  apk add --no-cache postgresql-client; \
  # Clean up
  rm -rf /var/cache/apk/*

RUN set -eux; \
  ARCH="$(uname -m)"; \
  case "${ARCH}" in \
  aarch64) \
  VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_arm64.zip"; \
  PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_arm64.zip"; \
  KUBECTL_DOWNLOAD_URL="https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl"; \
  HELM_DOWNLOAD_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-arm64.tar.gz"; \
  HELM_FOLDER="linux-arm64"; \
  INFRACOST_DOWNLOAD_FILE="infracost-linux-arm64"; \
  INFRACOST_ARCH="arm64"; \
  INFRACOST_DOWNLOAD_URL="https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}"; \
  COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-arm64"; \
  SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=aarch64&platform=Linux&package=sentry-cli"; \
  SENTRY_HASHSUM=$(curl "https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}" | jq -r '.files."sentry-cli-Linux-aarch64".checksums."sha256-hex"');\
  VAULT_CRD_RENDERER_URL="https://github.com/DaspawnW/vault-crd-helm-renderer/releases/download/v${VAULT_CRD_RENDERER_VERSION}"; \
  KYVERNO_CLI_DOWNLOAD_URL="https://github.com/kyverno/kyverno/releases/download/${KYVERNO_CLI_VERSION}/kyverno-cli_${KYVERNO_CLI_VERSION}_linux_arm64.tar.gz" \
  ;; \
  x86_64) \
  VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"; \
  PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"; \
  KUBECTL_DOWNLOAD_URL="https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
  HELM_DOWNLOAD_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"; \
  HELM_FOLDER="linux-amd64"; \
  INFRACOST_DOWNLOAD_FILE="infracost-linux-amd64"; \
  INFRACOST_ARCH="amd64"; \
  INFRACOST_DOWNLOAD_URL="https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}"; \
  COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64"; \
  SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=x86_64&platform=Linux&package=sentry-cli"; \
  SENTRY_HASHSUM=$(curl "https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}" | jq -r '.files."sentry-cli-Linux-x86_64".checksums."sha256-hex"');\
  VAULT_CRD_RENDERER_URL="https://github.com/DaspawnW/vault-crd-helm-renderer/releases/download/v${VAULT_CRD_RENDERER_VERSION}"; \
  KYVERNO_CLI_DOWNLOAD_URL="https://github.com/kyverno/kyverno/releases/download/${KYVERNO_CLI_VERSION}/kyverno-cli_${KYVERNO_CLI_VERSION}_linux_x86_64.tar.gz" \
  ;; \
  *) \
  echo "Unsupported arch: ${ARCH}"; \
  exit 1; \
  ;; \
  esac; \
  #### install boto3, checov, ansible, hvac and pre-commit
  pip3 install --no-cache-dir -U boto3 checkov==${CHECKOV_VERSION} ansible==${ANSIBLE_VERSION} hvac==${PIP_HVAC_VERSION} pre-commit jc; \
  #### install vault
  _vault_tmp_dir=$(mktemp -d) && cd "${_vault_tmp_dir}"; \
  curl -L "${VAULT_DOWNLOAD_URL}" -o "${_vault_tmp_dir}/vault.zip"; \
  unzip "${_vault_tmp_dir}/vault.zip" && mv "${_vault_tmp_dir}/vault" /usr/bin && cd ;\
  rm -rf "${_vault_tmp_dir}"; \
  #### install packer
  _packer_tmp_dir=$(mktemp -d) && cd "${_packer_tmp_dir}"; \
  curl -L "${PACKER_DOWNLOAD_URL}" -o "${_packer_tmp_dir}/packer.zip"; \
  unzip "${_packer_tmp_dir}/packer.zip" && mv packer /usr/bin && cd ; \
  rm -rf "${_packer_tmp_dir}"; \
  #### install kubectl
  curl -L "${KUBECTL_DOWNLOAD_URL}" -o "kubectl"; \
  chmod +x kubectl && mv kubectl /usr/bin; \
  #### install helm
  _helm_tmp_dir=$(mktemp -d) && cd "${_helm_tmp_dir}"; \
  curl -L "${HELM_DOWNLOAD_URL}" -o "${_helm_tmp_dir}/helm.tar.gz"; \
  tar -xvzf "${_helm_tmp_dir}/helm.tar.gz" && chmod +x "${_helm_tmp_dir}/${HELM_FOLDER}/helm" && mv "${_helm_tmp_dir}/${HELM_FOLDER}/helm" /usr/bin; \
  cd && rm -rf "${_helm_tmp_dir}"; \
  #### install infracost
  curl -L "${INFRACOST_DOWNLOAD_URL}/${INFRACOST_DOWNLOAD_FILE}.tar.gz" -o "${INFRACOST_DOWNLOAD_FILE}.tar.gz"; \
  curl -L "${INFRACOST_DOWNLOAD_URL}/${INFRACOST_DOWNLOAD_FILE}.tar.gz.sha256" -o "${INFRACOST_DOWNLOAD_FILE}.tar.gz.sha256"; \
  sha256sum -c "${INFRACOST_DOWNLOAD_FILE}.tar.gz.sha256"; \
  mkdir /opt/infracost_bin; \
  tar xf "${INFRACOST_DOWNLOAD_FILE}.tar.gz" -C /opt/infracost_bin/; \
  rm "${INFRACOST_DOWNLOAD_FILE}.tar.gz" "${INFRACOST_DOWNLOAD_FILE}.tar.gz.sha256"; \
  case "$(uname -m)" in \
  x86_64) arch="amd64" ;; \
  aarch64) arch="arm64" ;; \
  *) echo "Unsupported architecture: $(uname -m)" && exit 1 ;; \
  esac; \
  chmod +x "/opt/infracost_bin/infracost-linux-${arch}"; \
  mv "/opt/infracost_bin/infracost-linux-${arch}" /opt/infracost_bin/infracost; \
  ln -s /opt/infracost_bin/infracost /usr/local/bin/infracost; \
  #### install sentry-cli
  curl -L "${SENTRY_DOWNLOAD_URL}" -o sentry-cli; \
  echo "${SENTRY_HASHSUM}  sentry-cli" | sha256sum -c; \
  mv sentry-cli /usr/local/bin/sentry-cli; \
  chmod +x /usr/local/bin/sentry-cli; \
  #### install cosign
  curl -L "${COSIGN_DOWNLOAD_URL}" -o cosign; \
  chmod +x cosign; \
  mv cosign /usr/bin/cosign; \
  #### install vault crd post renderer
  curl -L "${VAULT_CRD_RENDERER_URL}/vault-crd-helm-renderer.jar" -o vault-crd-helm-renderer.jar; \
  curl -L "${VAULT_CRD_RENDERER_URL}/vault-crd-helm-renderer.jar.sha1" -o vault-crd-helm-renderer.jar.sha1; \
  sha1sum vault-crd-helm-renderer.jar; \
  mkdir -p /opt/daspawnw; \
  mv vault-crd-helm-renderer.jar /opt/daspawnw/vault-crd-helm-renderer.jar; \
  #### install tfenv
  mkdir -p /etc/tfenv; \
  git clone --depth 1 https://github.com/tfutils/tfenv.git /etc/tfenv; \
  chown -R jenkins /etc/tfenv; \
  #### install kyverno cli
  _kyverno_cli_tmp_dir=$(mktemp -d) && cd "${_kyverno_cli_tmp_dir}"; \
  curl -L "${KYVERNO_CLI_DOWNLOAD_URL}" -o "${_kyverno_cli_tmp_dir}/kyverno_cli.tar.gz"; \
  tar xzf "${_kyverno_cli_tmp_dir}/kyverno_cli.tar.gz"; \
  mv "${_kyverno_cli_tmp_dir}/kyverno" /usr/local/bin; \
  chmod +x /usr/local/bin/kyverno; \
  rm -rf "${_kyverno_cli_tmp_dir}"; \
  #### nix installation permissions
  mkdir /nix; \
  chown jenkins:jenkins /nix; 

COPY --chown=jenkins:jenkins jenkins-inbound-agent/bin/post-renderer.sh jenkins-inbound-agent/bin/check-default-namespace.sh /usr/bin/

USER jenkins

#### install terraform with tfenv and helm diff
RUN helm plugin install https://github.com/databus23/helm-diff

ENV PATH="/home/jenkins/.nix-profile/bin:$PATH:/etc/tfenv/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV NIX_PROFILES="/nix/var/nix/profiles/default /home/jenkins/.nix-profile"
ENV NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
ENV XDG_DATA_DIRS="$XDG_DATA_DIRS:/home/jenkins/.nix-profile/share:/nix/var/nix/profiles/default/share"

RUN tfenv install ${TERRAFORM_1_VERSION} \
  && tfenv use ${TERRAFORM_1_VERSION}

# test CLIs
RUN kubectl version --client && \
  helm version && \
  packer version && \
  vault version && \
  infracost --version && \
  cosign version && \
  sentry-cli --version && \
  kyverno version && \
  checkov --version && \
  ansible --version && \
  nix --version && \
  aws --version
