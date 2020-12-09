FROM jenkins/jnlp-slave:4.3-9

USER root

ARG VAULT_VERSION=1.5.3
ARG PACKER_VERSION=1.6.2
ARG TERRAFORM_11_VERSION=0.11.14
ARG TERRAFORM_12_VERSION=0.12.29
ARG TERRAFORM_13_VERSION=0.13.2
ARG TERRAFORM_14_VERSION=0.14.0
ARG KUBECTL_VERSION=1.18.0
ARG HELM_VERSION=3.1.2
ARG ANSIBLE_VERSION=2.10.3

RUN apt-get update && apt-get dist-upgrade -y \
      && apt-get install -y \
        git \
        apt-transport-https \
        curl \
        init \
        openssh-server openssh-client \
        software-properties-common \
        unzip \
        jq \
        python3-pip \
      && rm -rf /var/lib/apt/lists/* \

    #### install aws cli
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
      && unzip awscliv2.zip && ./aws/install && rm awscliv2.zip && rm -rf aws \

    #### install boto3
    && pip3 install -U boto3 \

    #### install ansible
    && pip3 install ansible==${ANSIBLE_VERSION} \

    #### install vault
    && curl "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" -o "vault.zip" \
      && unzip vault.zip && mv vault /usr/bin && rm vault.zip \

    #### install packer
    && curl "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" -o "packer.zip" \
      && unzip packer.zip && mv packer /usr/bin && rm packer.zip \

    #### install kubectl
    && curl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o "kubectl" \
      && chmod +x kubectl && mv kubectl /usr/bin \

    #### install helm
    && curl -L "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -o "helm.tar.gz" \
      && tar -xvzf helm.tar.gz && chmod +x linux-amd64/helm && mv linux-amd64/helm /usr/bin \
      && rm -rf linux-amd64 helm.tar.gz

USER jenkins
    #### install terraform with tfenv
RUN git clone https://github.com/tfutils/tfenv.git /home/jenkins/.tfenv \
      && export PATH="/home/jenkins/.tfenv/bin:${PATH}" \
      && tfenv install ${TERRAFORM_11_VERSION} \
      && tfenv install ${TERRAFORM_12_VERSION} \
      && tfenv install ${TERRAFORM_13_VERSION} \
      && tfenv install ${TERRAFORM_14_VERSION} \
      && tfenv use ${TERRAFORM_13_VERSION}

ENV PATH "$PATH:/home/jenkins/.tfenv/bin"
