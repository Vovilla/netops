FROM ubuntu:22.04
RUN echo "===> Install packages ..."
COPY apt-install.sh /tmp/apt-install.sh
COPY requirements-apt.txt /tmp/requirements-apt.txt

RUN mkdir /etc/ansible/
COPY ansible.cfg /etc/ansible/ansible.cfg
RUN mkdir -p /etc/ansible/library/ntc-ansible/
COPY ntc-ansible /etc/ansible/library/ntc-ansible/
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN bash /tmp/apt-install.sh
RUN echo "===> Install Ansible (Core & Collections) & dependency Python packages ..."
COPY requirements-pip.txt /tmp/requirements-pip.txt
COPY requirements-ansible.yml /tmp/requirements-ansible.yml
RUN pip3 install --upgrade -r /tmp/requirements-pip.txt  && \
     ansible-galaxy collection install -p /usr/share/ansible/collections -r /tmp/requirements-ansible.yml
RUN echo "===> Clean up ..."
RUN apt clean && \
      rm -rf /tmp/*

RUN echo "===> Enable ssh options for cisco ..."
RUN echo "    KexAlgorithms +diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1" | tee -a /etc/ssh/ssh_config
RUN echo "    HostkeyAlgorithms +ssh-rsa" | tee -a /etc/ssh/ssh_config
RUN echo "    PubkeyAcceptedAlgorithms +ssh-rsa" | tee -a /etc/ssh/ssh_config

WORKDIR /ansible