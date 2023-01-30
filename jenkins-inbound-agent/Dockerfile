FROM jenkins/inbound-agent:4.13.2-1

USER root

ARG VAULT_VERSION=1.5.3
ARG PACKER_VERSION=1.8.1
ARG TERRAFORM_1_VERSION=1.0.5
ARG TERRAFORM_1_1_VERSION=1.1.9
ARG KUBECTL_VERSION=1.24.9
ARG HELM_VERSION=3.9.0
ARG ANSIBLE_VERSION=7.1.0
ARG TERRAFORM_DOCS_VERSION=0.10.1
ARG CONFTEST_VERSION=0.23.0
ARG TRIVY_VERSION=0.27.1
ARG SONAR_SCANNER_VERSION=4.7.0.2747
ARG INFRACOST_VERSION=v0.9.24
ARG SONOBUOY_VERSION=0.56.6
ARG COSIGN_VERSION=1.10.1
ARG SENTRY_CLI_VERSION=2.5.0
ARG CHECKOV_VERSION=2.2.234
ARG VAULT_CRD_RENDERER_VERSION=1.0.0

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
          HELM_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM_VERSION}-linux-arm64.tar.gz"; \
          HELM_FOLDER="linux-arm64"; \
          TERRAFORM_DOCS_DOWNLOAD_FILE="terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-arm64"; \
          TERRAFORM_DOCS_DOWNLOAD_URL="https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-arm64"; \
          CONFTEST_DOWNLOAD_URL="https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_arm64.tar.gz"; \
          TRIVY_DOWNLOAD_URL="https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-ARM64.deb"; \
          INFRACOST_DOWNLOAD_FILE="infracost-linux-arm64"; \
          INFRACOST_DOWNLOAD_URL="https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}"; \
          SONOBUOY_DOWNLOAD_FILE="sonobuoy_${SONOBUOY_VERSION}_linux_arm64"; \
          SONOBUOY_DOWNLOAD_URL="https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}"; \
          COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign_${COSIGN_VERSION}_arm64.deb"; \
          SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=aarch64&platform=Linux&package=sentry-cli"; \
          SENTRY_HASHSUM="4d4bfdefc86738feec7e59ff5b0e7c824c37fa8c150e8926a020b0a1e4f84120"; \
         ;; \
       amd64|x86_64) \
          AWS_CLI_DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"; \
          VAULT_DOWNLOAD_URL="https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"; \
          PACKER_DOWNLOAD_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"; \
          KUBECTL_DOWNLOAD_URL="https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
          HELM_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"; \
          HELM_FOLDER="linux-amd64"; \
          TERRAFORM_DOCS_DOWNLOAD_FILE="terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64"; \
          TERRAFORM_DOCS_DOWNLOAD_URL="https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64"; \
          CONFTEST_DOWNLOAD_URL="https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"; \
          TRIVY_DOWNLOAD_URL="https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.deb"; \
          INFRACOST_DOWNLOAD_FILE="infracost-linux-amd64"; \
          INFRACOST_DOWNLOAD_URL="https://github.com/infracost/infracost/releases/download/${INFRACOST_VERSION}"; \
          SONOBUOY_DOWNLOAD_FILE="sonobuoy_${SONOBUOY_VERSION}_linux_amd64"; \
          SONOBUOY_DOWNLOAD_URL="https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY_VERSION}"; \
          COSIGN_DOWNLOAD_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign_${COSIGN_VERSION}_amd64.deb"; \
          SENTRY_DOWNLOAD_URL="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=x86_64&platform=Linux&package=sentry-cli"; \
          SENTRY_HASHSUM="f35d3cee001eb20b0706da9ddd939890371b0fd7b430a7ef3d3dfae8718b75a3"; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \

    #### install aws cli
    curl "${AWS_CLI_DOWNLOAD_URL}" -o "awscliv2.zip"; \
      unzip awscliv2.zip && ./aws/install && rm awscliv2.zip && rm -rf aws; \

    #### install boto3, checov and pre-commit
    pip3 install --no-cache-dir -U boto3 checkov==${CHECKOV_VERSION} pre-commit; \

    #### install ansible
    pip3 install --no-cache-dir ansible==${ANSIBLE_VERSION}; \

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

    #### install terraform-docs
    curl -L "${TERRAFORM_DOCS_DOWNLOAD_URL}" -o "terraform-docs"; \
      mv terraform-docs /usr/local/bin/terraform-docs; \
      chmod a+x /usr/local/bin/terraform-docs; \

    #### install conftest (aka opa)
    curl -L "${CONFTEST_DOWNLOAD_URL}" -o "conftest_${CONFTEST_VERSION}.tar.gz"; \
      tar xzf "conftest_${CONFTEST_VERSION}.tar.gz"; \
      mv conftest /usr/local/bin; \
      chmod +x /usr/local/bin/conftest; \
      rm "conftest_${CONFTEST_VERSION}.tar.gz"; \

    #### install trivy
    curl -L "${TRIVY_DOWNLOAD_URL}" -o trivy.deb; \
      dpkg -i trivy.deb; \
      rm trivy.deb; \
      pip3 install --no-cache-dir pyyaml nested-lookup; \
 
    #### install sonar scanner cli
    curl -L "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip" -o "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip"; \
      curl -L "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip.sha256" -o "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip.sha256"; \
      echo $(cat "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip.sha256")  "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip" | sha256sum -c; \
      unzip "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip"; \
      rm "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip" "sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip.sha256"; \
      chmod +x "sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner"; \
      mv "sonar-scanner-${SONAR_SCANNER_VERSION}" "/opt/sonar-scanner-${SONAR_SCANNER_VERSION}"; \
      ln -s "/opt/sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner" /usr/local/bin/sonar-scanner; \

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

    #### install sonobuoy
    curl -L "${SONOBUOY_DOWNLOAD_URL}/${SONOBUOY_DOWNLOAD_FILE}.tar.gz" -o "${SONOBUOY_DOWNLOAD_FILE}.tar.gz"; \
      curl -L "${SONOBUOY_DOWNLOAD_URL}/sonobuoy_${SONOBUOY_VERSION}_checksums.txt" -o "sonobuoy_${SONOBUOY_VERSION}_checksums.txt"; \
      sha256sum --ignore-missing -c "sonobuoy_${SONOBUOY_VERSION}_checksums.txt"; \
      tar -xvzf "${SONOBUOY_DOWNLOAD_FILE}.tar.gz"; \
      mv ./sonobuoy /usr/local/bin/sonobuoy; \
      chmod +x /usr/local/bin/sonobuoy; \
      rm "${SONOBUOY_DOWNLOAD_FILE}.tar.gz" "sonobuoy_${SONOBUOY_VERSION}_checksums.txt" LICENSE; \

    #### install sentry-cli
    curl -L "${SENTRY_DOWNLOAD_URL}" -o sentry-cli; \
      echo "${SENTRY_HASHSUM}  sentry-cli" | sha256sum -c; \
      mv sentry-cli /usr/local/bin/sentry-cli; \
      chmod +x /usr/local/bin/sentry-cli; \

    #### install cosign
    curl -L "${COSIGN_DOWNLOAD_URL}" -o cosign.deb; \
      dpkg -i cosign.deb; \
      rm cosign.deb; \

    #### install vault crd post renderer #TODO: Sha1 check when available
    curl -L "https://github.com/DaspawnW/vault-crd-helm-renderer/releases/download/v${VAULT_CRD_RENDERER_VERSION}/vault-crd-helm-renderer.jar" -o vault-crd-helm-renderer.jar; \
      mkdir -p /opt/daspawnw; \
      mv vault-crd-helm-renderer.jar /opt/daspawnw/vault-crd-helm-renderer.jar; \

    #### install tfenv
    mkdir -p /etc/tfenv; \
     git clone --depth 1 https://github.com/tfutils/tfenv.git /etc/tfenv; \
     chown -R jenkins /etc/tfenv; 

COPY --chown=jenkins:jenkins jenkins-inbound-agent/bin/post-renderer.sh /usr/bin/post-renderer.sh

USER jenkins
    #### install terraform with tfenv and helm diff

RUN helm plugin install https://github.com/databus23/helm-diff

ENV PATH "$PATH:/etc/tfenv/bin"
RUN tfenv install ${TERRAFORM_1_VERSION} \
      && tfenv install ${TERRAFORM_1_1_VERSION} \
      && tfenv use ${TERRAFORM_1_VERSION}
