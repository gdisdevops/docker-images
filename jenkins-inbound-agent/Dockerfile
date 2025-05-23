FROM jenkins/inbound-agent:3309.v27b_9314fd1a_4-2-jdk21

USER root

ARG VAULT_VERSION=1.18.3
ARG PACKER_VERSION=1.12.0
ARG VAULT_VERSION=1.19.4
ARG TERRAFORM_1_VERSION=1.12.0
ARG KUBECTL_VERSION=1.31.8
ARG HELM_VERSION=v3.17.1
ARG ANSIBLE_VERSION=11.5.0
ARG INFRACOST_VERSION=v0.10.40
ARG COSIGN_VERSION=2.5.0
ARG SENTRY_CLI_VERSION=2.45.0
ARG CHECKOV_VERSION=3.2.424
ARG VAULT_CRD_RENDERER_VERSION=1.0.7
ARG PIP_HVAC_VERSION=2.3.0
ARG KYVERNO_CLI_VERSION=v1.12.6

ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN set -eux; \
    apt-get update && \
    apt-get install -y curl ca-certificates gnupg lsb-release; \
    install -d /usr/share/postgresql-common/pgdg; \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc; \
    sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y \
        git \
        apt-transport-https \
        init \
        openssh-server openssh-client \
        software-properties-common \
        postgresql-client-16 \
        unzip \
        libffi-dev \
        jq \
        jc \
        yq \
        xxd \
        python3-pip && \
    python3 -m pip install --upgrade pip && \
    rm -rf /var/lib/apt/lists/* 

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
          AWS_CLI_DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"; \
          VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_arm64.zip"; \
          PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_arm64.zip"; \
          KUBECTL_DOWNLOAD_URL="https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl"; \
          HELM_DOWNLOAD_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-arm64.tar.gz"; \
          HELM_FOLDER="linux-arm64"; \
          INFRACOST_DOWNLOAD_FILE="infracost-linux-arm64"; \
          INFRACOST_DOWNLOAD_URL="https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}"; \
          COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign_${COSIGN_VERSION}_arm64.deb"; \
          SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=aarch64&platform=Linux&package=sentry-cli"; \
          SENTRY_HASHSUM=$(curl "https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}" | jq -r '.files."sentry-cli-Linux-aarch64".checksums."sha256-hex"');\
          VAULT_CRD_RENDERER_URL="https://github.com/DaspawnW/vault-crd-helm-renderer/releases/download/v${VAULT_CRD_RENDERER_VERSION}"; \
          KYVERNO_CLI_DOWNLOAD_URL="https://github.com/kyverno/kyverno/releases/download/${KYVERNO_CLI_VERSION}/kyverno-cli_${KYVERNO_CLI_VERSION}_linux_arm64.tar.gz" \
         ;; \
       amd64|x86_64) \
          AWS_CLI_DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"; \
          VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"; \
          PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"; \
          KUBECTL_DOWNLOAD_URL="https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
          HELM_DOWNLOAD_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"; \
          HELM_FOLDER="linux-amd64"; \
          INFRACOST_DOWNLOAD_FILE="infracost-linux-amd64"; \
          INFRACOST_DOWNLOAD_URL="https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}"; \
          COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign_${COSIGN_VERSION}_amd64.deb"; \
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
    #### install aws cli
    _aws_cli_tmp_dir=$(mktemp -d) && cd "${_aws_cli_tmp_dir}"; \
      curl "${AWS_CLI_DOWNLOAD_URL}" -o "${_aws_cli_tmp_dir}/awscliv2.zip"; \
      unzip "${_aws_cli_tmp_dir}/awscliv2.zip" && ./aws/install && cd ; \
      rm -rf "${_aws_cli_tmp_dir}"; \
    #### install boto3, checov, ansible, hvac and pre-commit
    pip3 install --no-cache-dir -U boto3 checkov==${CHECKOV_VERSION} ansible==${ANSIBLE_VERSION} hvac==${PIP_HVAC_VERSION} pre-commit; \
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
      chmod +x "/opt/infracost_bin/infracost-linux-$(dpkg --print-architecture)"; \
      mv "/opt/infracost_bin/infracost-linux-$(dpkg --print-architecture)" /opt/infracost_bin/infracost; \
      ln -s /opt/infracost_bin/infracost /usr/local/bin/infracost; \
    #### install sentry-cli
    curl -L "${SENTRY_DOWNLOAD_URL}" -o sentry-cli; \
      echo "${SENTRY_HASHSUM}  sentry-cli" | sha256sum -c; \
      mv sentry-cli /usr/local/bin/sentry-cli; \
      chmod +x /usr/local/bin/sentry-cli; \
    #### install cosign
    curl -L "${COSIGN_DOWNLOAD_URL}" -o cosign.deb; \
      dpkg -i cosign.deb; \
      rm cosign.deb; \
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
      rm -rf "${_kyverno_cli_tmp_dir}"; 

COPY --chown=jenkins:jenkins jenkins-inbound-agent/bin/post-renderer.sh jenkins-inbound-agent/bin/check-default-namespace.sh /usr/bin/

USER jenkins
    #### install terraform with tfenv and helm diff

RUN helm plugin install https://github.com/databus23/helm-diff

ENV PATH "$PATH:/etc/tfenv/bin"
RUN tfenv install ${TERRAFORM_1_VERSION} \
      && tfenv use ${TERRAFORM_1_VERSION}

# test CLIs
RUN kubectl version && \
    helm version && \
    aws --version && \
    packer version && \
    vault version && \
    infracost --version && \
    cosign version && \
    sentry-cli --version && \
    kyverno version && \
    checkov --version
