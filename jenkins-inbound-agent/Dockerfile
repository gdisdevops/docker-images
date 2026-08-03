## FIXME: workaround for c3x breaking changes in CLI
FROM ghcr.io/gdisdevops/docker-images/jenkins-inbound-agent:v4.3.0 AS c3x-legacy

FROM jenkins/inbound-agent:alpine-jdk21

USER root

ARG VAULT_VERSION=1.21.4
ARG PACKER_VERSION=1.15.3
ARG TERRAFORM_1_VERSION=1.15.8
ARG KUBECTL_VERSION=1.34.6
ARG HELM_VERSION=3.21.3
ARG ANSIBLE_VERSION=11.13.0
ARG C3X_VERSION=0.2.1
ARG COSIGN_VERSION=2.6.4
ARG SENTRY_CLI_VERSION=2.58.6
ARG CHECKOV_VERSION=3.3.8
ARG VAULT_CRD_RENDERER_VERSION=1.0.8
ARG PIP_HVAC_VERSION=2.4.0
ARG KYVERNO_CLI_VERSION=1.18.2
ARG NIXOS_CHANNEL=nixos-25.11
ARG TENV_VERSION=4.15.1

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
  ARCH="$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')"; \
  case "${ARCH}" in \
  arm64) \
  VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_arm64.zip"; \
  PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_arm64.zip"; \
  KUBECTL_DOWNLOAD_URL="https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl"; \
  HELM_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM_VERSION}-linux-arm64.tar.gz"; \
  C3X_DOWNLOAD_URL="https://github.com/c3xdev/c3x/releases/download/v${C3X_VERSION}"; \
  COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-arm64"; \
  SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=aarch64&platform=Linux&package=sentry-cli"; \
  SENTRY_HASHSUM=$(curl "https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}" | jq -r '.files."sentry-cli-Linux-aarch64".checksums."sha256-hex"');\
  VAULT_CRD_RENDERER_URL="https://github.com/DaspawnW/vault-crd-helm-renderer/releases/download/v${VAULT_CRD_RENDERER_VERSION}"; \
  KYVERNO_CLI_DOWNLOAD_URL="https://github.com/kyverno/kyverno/releases/download/v${KYVERNO_CLI_VERSION}/kyverno-cli_v${KYVERNO_CLI_VERSION}_linux_arm64.tar.gz"; \
  TENV_DOWNLOAD_URL="https://github.com/tofuutils/tenv/releases/download/v${TENV_VERSION}/tenv_v${TENV_VERSION}_Linux_arm64.tar.gz" \
  ;; \
  amd64) \
  VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"; \
  PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"; \
  KUBECTL_DOWNLOAD_URL="https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
  HELM_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"; \
  C3X_DOWNLOAD_URL="https://github.com/c3xdev/c3x/releases/download/v${C3X_VERSION}"; \
  COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64"; \
  SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=x86_64&platform=Linux&package=sentry-cli"; \
  SENTRY_HASHSUM=$(curl "https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}" | jq -r '.files."sentry-cli-Linux-x86_64".checksums."sha256-hex"');\
  VAULT_CRD_RENDERER_URL="https://github.com/DaspawnW/vault-crd-helm-renderer/releases/download/v${VAULT_CRD_RENDERER_VERSION}"; \
  KYVERNO_CLI_DOWNLOAD_URL="https://github.com/kyverno/kyverno/releases/download/v${KYVERNO_CLI_VERSION}/kyverno-cli_v${KYVERNO_CLI_VERSION}_linux_x86_64.tar.gz" \
  TENV_DOWNLOAD_URL="https://github.com/tofuutils/tenv/releases/download/v${TENV_VERSION}/tenv_v${TENV_VERSION}_Linux_x86_64.tar.gz" \
  ;; \
  *) \
  echo "Unsupported arch: ${ARCH}"; \
  exit 1; \
  ;; \
  esac; \
  #### install boto3, checkov, ansible, hvac and pre-commit. Pin setuptools for distutils Ansible issue
  pip3 install --no-cache-dir -U "setuptools<81" boto3 checkov==${CHECKOV_VERSION} ansible==${ANSIBLE_VERSION} hvac==${PIP_HVAC_VERSION} pre-commit jc; \
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
  HELM_FOLDER="linux-${ARCH}"; \
  _helm_tmp_dir=$(mktemp -d) && cd "${_helm_tmp_dir}"; \
  curl -L "${HELM_DOWNLOAD_URL}" -o "${_helm_tmp_dir}/helm.tar.gz"; \
  tar -xvzf "${_helm_tmp_dir}/helm.tar.gz" && chmod +x "${_helm_tmp_dir}/${HELM_FOLDER}/helm" && mv "${_helm_tmp_dir}/${HELM_FOLDER}/helm" /usr/bin; \
  cd && rm -rf "${_helm_tmp_dir}"; \
  #### install c3x
  # C3X_DOWNLOAD_FILE="c3x_${C3X_VERSION}_linux_${ARCH}"; \
  # curl -L -f "${C3X_DOWNLOAD_URL}/${C3X_DOWNLOAD_FILE}.tar.gz" -o "${C3X_DOWNLOAD_FILE}.tar.gz"; \
  # curl -L -f "${C3X_DOWNLOAD_URL}/checksums.txt" -o "${C3X_DOWNLOAD_FILE}.tar.gz.sha256"; \
  # sha256sum --ignore-missing -c "${C3X_DOWNLOAD_FILE}.tar.gz.sha256"; \
  mkdir /opt/c3x_bin; \
  # FIXME: workaround for c3x breaking changes in CLI
  # tar xf "${C3X_DOWNLOAD_FILE}.tar.gz" -C /opt/c3x_bin/; \
  # rm "${C3X_DOWNLOAD_FILE}.tar.gz" "${C3X_DOWNLOAD_FILE}.tar.gz.sha256"; \
  # chmod +x "/opt/c3x_bin/c3x"; \
  # ln -s /opt/c3x_bin/c3x /usr/local/bin/c3x; \
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
  #### install tenv
  _tenv_tmp_dir=$(mktemp -d) && cd "${_tenv_tmp_dir}"; \
  curl -L "${TENV_DOWNLOAD_URL}" -o "tenv.tar.gz"; \
  tar -xvzf "tenv.tar.gz" && chmod +x "tenv" && mv "tenv" /usr/bin; \
  cd && rm -rf "${_tenv_tmp_dir}"; \
  #### install kyverno cli
  _kyverno_cli_tmp_dir=$(mktemp -d) && cd "${_kyverno_cli_tmp_dir}"; \
  curl -L "${KYVERNO_CLI_DOWNLOAD_URL}" -o "${_kyverno_cli_tmp_dir}/kyverno_cli.tar.gz"; \
  tar xzf "${_kyverno_cli_tmp_dir}/kyverno_cli.tar.gz"; \
  mv "${_kyverno_cli_tmp_dir}/kyverno" /usr/local/bin; \
  chmod +x /usr/local/bin/kyverno; \
  rm -rf "${_kyverno_cli_tmp_dir}"; \
  #### nix installation permissions
  mkdir -p /nix/var/nix/profiles /nix/var/nix/gcroots /nix/var/nix/db; \
  chown -R jenkins:jenkins /nix;

COPY --chown=jenkins:jenkins jenkins-inbound-agent/bin/post-renderer.sh jenkins-inbound-agent/bin/check-default-namespace.sh /usr/bin/

## FIXME: workaround for c3x breaking changes in CLI
COPY --from=c3x-legacy /opt/c3x_bin/c3x /opt/c3x_bin/c3x-legacy
RUN ln -s /opt/c3x_bin/c3x-legacy /usr/local/bin/c3x

USER jenkins

#### install helm diff
RUN helm plugin install https://github.com/databus23/helm-diff

#### nix setup
ENV PATH="/home/jenkins/.nix-profile/bin:$PATH"
ENV NIX_PROFILES="/nix/var/nix/profiles/default /home/jenkins/.nix-profile"
ENV NIX_SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
ENV XDG_DATA_DIRS="/home/jenkins/.nix-profile/share:/nix/var/nix/profiles/default/share"

RUN nix-channel --add https://nixos.org/channels/${NIXOS_CHANNEL} nixpkgs && \
    nix-channel --update

#### install terraform with tenv
RUN tenv tf install ${TERRAFORM_1_VERSION} \
  && tenv tf use ${TERRAFORM_1_VERSION}
ENV PATH="/home/jenkins/.tenv/Terraform/${TERRAFORM_1_VERSION}:$PATH"

#### test CLIs
RUN kubectl version --client && \
  helm version && \
  packer version && \
  vault version && \
  c3x --version && \
  cosign version && \
  sentry-cli --version && \
  kyverno version && \
  checkov --version && \
  ansible --version && \
  nix --version && \
  aws --version && \
  tenv --version && \
  terraform -version
