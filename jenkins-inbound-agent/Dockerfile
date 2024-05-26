FROM jenkins/inbound-agent:3148.v532a_7e715ee3-7

USER root

ARG VAULT_VERSION=1.16.1
ARG PACKER_VERSION=1.10.2
ARG TERRAFORM_1_VERSION=1.8.4
ARG KUBECTL_VERSION=1.26.8
ARG HELM_VERSION=v3.12.3
ARG ANSIBLE_VERSION=9.4.0
ARG INFRACOST_VERSION=v0.10.29
ARG COSIGN_VERSION=1.13.6
ARG SENTRY_CLI_VERSION=2.31.0
ARG CHECKOV_VERSION=3.2.72
ARG VAULT_CRD_RENDERER_VERSION=1.0.7
ARG PIP_HVAC_VERSION=2.1.0
ARG KYVERNO_CLI_VERSION=v1.11.4

ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN set -eux; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y \
        git \
        apt-transport-https \
        curl \
        init \
        openssh-server openssh-client \
        software-properties-common \
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
          KUBECTL_DOWNLOAD_URL="https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl"; \
          HELM_DOWNLOAD_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-arm64.tar.gz"; \
          HELM_FOLDER="linux-arm64"; \
          INFRACOST_DOWNLOAD_FILE="infracost-linux-arm64"; \
          INFRACOST_DOWNLOAD_URL="https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}"; \
          COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign_${COSIGN_VERSION}_arm64.deb"; \
          SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=aarch64&platform=Linux&package=sentry-cli"; \
          SENTRY_HASHSUM="2b92198d58ffd2f4551db6782b42b42ecc1ba3c7c7864f0c4ae84be940f927d3"; \
          VAULT_CRD_RENDERER_URL="https://github.com/DaspawnW/vault-crd-helm-renderer/releases/download/v${VAULT_CRD_RENDERER_VERSION}"; \
          KYVERNO_CLI_DOWNLOAD_URL="https://github.com/kyverno/kyverno/releases/download/${KYVERNO_CLI_VERSION}/kyverno-cli_${KYVERNO_CLI_VERSION}_linux_arm64.tar.gz" \
         ;; \
       amd64|x86_64) \
          AWS_CLI_DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"; \
          VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"; \
          PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"; \
          KUBECTL_DOWNLOAD_URL="https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
          HELM_DOWNLOAD_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"; \
          HELM_FOLDER="linux-amd64"; \
          INFRACOST_DOWNLOAD_FILE="infracost-linux-amd64"; \
          INFRACOST_DOWNLOAD_URL="https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}"; \
          COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign_${COSIGN_VERSION}_amd64.deb"; \
          SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=x86_64&platform=Linux&package=sentry-cli"; \
          SENTRY_HASHSUM="baeb5b4ca0a5e500d667087f0b7fbb2865d3b8f01896cfba5144433dbe59bebd"; \
          VAULT_CRD_RENDERER_URL="https://github.com/DaspawnW/vault-crd-helm-renderer/releases/download/v${VAULT_CRD_RENDERER_VERSION}"; \
          KYVERNO_CLI_DOWNLOAD_URL="https://github.com/kyverno/kyverno/releases/download/${KYVERNO_CLI_VERSION}/kyverno-cli_${KYVERNO_CLI_VERSION}_linux_x86_64.tar.gz" \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \

    #### install aws cli
    curl "${AWS_CLI_DOWNLOAD_URL}" -o "awscliv2.zip"; \
      unzip awscliv2.zip && ./aws/install && rm awscliv2.zip && rm -rf aws; \

    #### install boto3, checov, ansible, hvac and pre-commit
    pip3 install --no-cache-dir -U boto3 checkov==${CHECKOV_VERSION} ansible==${ANSIBLE_VERSION} hvac==${PIP_HVAC_VERSION} pre-commit; \
    
    #### install vault
    curl -L "${VAULT_DOWNLOAD_URL}" -o "vault.zip"; \
      unzip vault.zip && mv vault /usr/bin && rm vault.zip; \

    #### install packer
    curl -L "${PACKER_DOWNLOAD_URL}" -o "packer.zip"; \
      unzip packer.zip && mv packer /usr/bin && rm packer.zip; \

    #### install kubectl
    curl -L "${KUBECTL_DOWNLOAD_URL}" -o "kubectl"; \
      chmod +x kubectl && mv kubectl /usr/bin; \

    #### install helm
    curl -L "${HELM_DOWNLOAD_URL}" -o "helm.tar.gz"; \
      tar -xvzf helm.tar.gz && chmod +x "${HELM_FOLDER}/helm" && mv "${HELM_FOLDER}/helm" /usr/bin; \
      rm -rf "${HELM_FOLDER}" helm.tar.gz; \

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
    curl -L "${KYVERNO_CLI_DOWNLOAD_URL}" -o "kyverno_cli.tar.gz"; \
      tar xzf "kyverno_cli.tar.gz"; \
      mv kyverno /usr/local/bin; \
      chmod +x /usr/local/bin/kyverno; \
      rm "kyverno_cli.tar.gz" "LICENSE"; 

COPY --chown=jenkins:jenkins jenkins-inbound-agent/bin/post-renderer.sh jenkins-inbound-agent/bin/check-default-namespace.sh /usr/bin/

USER jenkins
    #### install terraform with tfenv and helm diff

RUN helm plugin install https://github.com/databus23/helm-diff

ENV PATH "$PATH:/etc/tfenv/bin"
RUN tfenv install ${TERRAFORM_1_VERSION} \
      && tfenv use ${TERRAFORM_1_VERSION}
