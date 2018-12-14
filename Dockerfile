# Infrastructure-as-Code TestKit for Amazon Linux
#
# VERSION 2.0.20181114

FROM amazonlinux:2

ENV DEBIAN_FRONTEND=noninteractive

COPY requirements.txt requirements.txt

RUN yum update -y -q &&\
    yum erase -y -q docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-selinux \
        docker-engine-selinux \
        docker-engine &&\
    yum install -y -q \
        gcc \
        gzip \
        jq \
        python2-devel \
        python2-setuptools \
        unzip &&\
    amazon-linux-extras install -y -q \
        docker &&\
    yum upgrade -y -q &&\
    yum clean all -y -q &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime &&\
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/timezone &&\
    easy_install -q --upgrade pip &&\
    pip install --ignore-installed --upgrade -qqq -r requirements.txt &&\
    curl -fsSL -o terraform.zip https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip &&\
    unzip -o -qq terraform.zip -d /usr/bin/ &&\
    curl -fsSL -o packer.zip https://releases.hashicorp.com/packer/1.3.2/packer_1.3.2_linux_amd64.zip &&\
    unzip -o -qq packer.zip -d /usr/bin/ &&\
    curl -fsSL -o vault.zip https://releases.hashicorp.com/vault/1.0.0/vault_1.0.0_linux_amd64.zip &&\
    unzip -o -qq vault.zip -d /usr/bin/ &&\
    curl -fsSL -o consul.zip https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip &&\
    unzip -o -qq consul.zip -d /usr/bin/ &&\
    curl -fsSL -o /usr/bin/terratest_log_parser https://github.com/gruntwork-io/terratest/releases/download/v0.13.13/terratest_log_parser_linux_amd64

ENTRYPOINT [ "/bin/bash", "-c" ]
