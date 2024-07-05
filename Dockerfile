# hadolint global ignore=SC2086,DL3003,DL3013,DL3033
FROM docker.io/rockylinux/rockylinux:9-ubi-init
LABEL maintainer="Tim Gruetzmacher"
LABEL org.opencontainers.image.source="https://github.com/TimGrt/docker-rockylinux9-ansible"

# Install requirements.
RUN yum -y install rpm dnf-plugins-core \
 && yum -y update \
 && yum -y install \
      epel-release \
      initscripts \
      sudo \
      which \
      hostname \
 && yum clean all

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Create `ansible` user with sudo permissions
ENV ANSIBLE_USER=ansible

RUN set -xe \
  && useradd -m ${ANSIBLE_USER} \
  && echo "${ANSIBLE_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ansible

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
