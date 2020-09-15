FROM jenkins/jnlp-slave:4.3-9

USER root

ARG VAULT_VERSION=1.5.3
ARG PACKER_VERSION=1.6.2
ARG TERRAFORM_11_VERSION=0.11.14
ARG TERRAFORM_13_VERSION=0.13.2
ARG KUBECTL_VERSION=1.18.0

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
        ansible \
      && rm -rf /var/lib/apt/lists/* \

    #### install aws cli
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
      && unzip awscliv2.zip && ./aws/install && rm awscliv2.zip && rm -rf aws \

    #### install boto3
    && pip3 install -U boto3 \
    
    #### install vault
    && curl "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" -o "vault.zip" \
      && unzip vault.zip && mv vault /usr/bin && rm vault.zip \

    #### install packer
    && curl "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" -o "packer.zip" \
      && unzip packer.zip && mv packer /usr/bin && rm packer.zip \

    #### install terraform 11
    && curl "https://releases.hashicorp.com/terraform/${TERRAFORM_11_VERSION}/terraform_${TERRAFORM_11_VERSION}_linux_amd64.zip" -o "terraform.zip" \
      && unzip terraform.zip && mv terraform /usr/bin/tf11 && rm terraform.zip \
    
    #### install terraform 13
    && curl "https://releases.hashicorp.com/terraform/${TERRAFORM_13_VERSION}/terraform_${TERRAFORM_12_VERSION}_linux_amd64.zip" -o "terraform.zip" \
      && unzip terraform.zip && mv terraform /usr/bin && rm terraform.zip \

    #### install kubectl
    && curl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o "kubectl" \
      && chmod +x kubectl && mv kubectl /usr/bin

USER jenkins
