#!/bin/bash
sudo yum update -y
sudo yum install -y -q -e 0 unzip nmap
sudo mkfs -t ext4 /dev/xvdg
sudo mkdir /var/lib/elasticsearch
sudo mount /dev/xvdg /var/lib/elasticsearch
echo "echo /dev/xvdg /var/lib/elasticsearch ext4 defaults,nofail 0 2 >> /etc/fstab" | sudo bash
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.0-x86_64.rpm
sudo rpm -ivh elasticsearch-7.6.0-x86_64.rpm
sudo sysctl -w vm.max_map_count=262144
echo "echo '${cert_data}' | base64 --decode >> ca.p12" | sudo bash
echo "instances:
  - name: `hostname`
    dns:
      - localhost
      - `curl -s http://169.254.169.254/latest/meta-data/public-hostname`
      - `hostname`
    ip:
      - 127.0.0.1
      - `dig +short myip.opendns.com @resolver1.opendns.com`
      - `curl -s http://169.254.169.254/latest/meta-data/local-ipv4`" >> instances.yaml 
sudo mv instances.yaml /usr/share/elasticsearch/
sudo cp ca.p12 /usr/share/elasticsearch/
mkdir -p /etc/elasticsearch/certificates/ca/
sudo  mv ca.p12 /etc/elasticsearch/certificates/ca/
sudo /usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca ca.p12 --silent --pem --in instances.yaml -out bundle.zip --ca-pass ${cert_file_passwd};
sudo unzip /usr/share/elasticsearch/bundle.zip -d /etc/elasticsearch/certificates/

echo "echo 'node.name: `hostname`
cluster.name: es-cluster
discovery.seed_hosts: [`nmap -sP 10.0.5.1/24 | awk '{for(i=1;i<=NF;i++){if($i~/^ip-/){print $i}}}' | sed ':a;N;$!ba;s/\n/,/g'`]
cluster.initial_master_nodes: [`nmap -sP 10.0.5.1/24 | awk '{for(i=1;i<=NF;i++){if($i~/^ip-/){print $i}}}' | sed ':a;N;$!ba;s/\n/,/g'`]
bootstrap.memory_lock: true
xpack.license.self_generated.type: trial
xpack.security.enabled: true
xpack.security.http.ssl.enabled: true
xpack.security.transport.ssl.keystore.path: /etc/elasticsearch/certificates/ca/ca.p12
xpack.security.transport.ssl.truststore.path: /etc/elasticsearch/certificates/ca/ca.p12
xpack.security.http.ssl.keystore.path: /etc/elasticsearch/certificates/ca/ca.p12
xpack.security.http.ssl.truststore.path: /etc/elasticsearch/certificates/ca/ca.p12
xpack.security.http.ssl.certificate: /etc/elasticsearch/certificates/`hostname`/`hostname`.crt
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.certificate: /etc/elasticsearch/certificates/`hostname`/`hostname`.crt
network.host: 0.0.0.0' >> /etc/elasticsearch/elasticsearch.yml" | sudo bash

echo "echo '# allow user 'elasticsearch' mlockall
elasticsearch soft memlock unlimited
elasticsearch hard memlock unlimited' >> /etc/security/limits.conf" | sudo bash

sudo mkdir -p /etc/systemd/system/elasticsearch.service.d
echo "echo '[Service]
LimitMEMLOCK=infinity
Restart=always
RestartSec=2' >> /etc/systemd/system/elasticsearch.service.d/override.conf" | sudo bash

sudo sed -i -e 's/-Xms1g/-Xms512m/g' /etc/elasticsearch/jvm.options
sudo sed -i -e 's/-Xmx1g/-Xmx512m/g' /etc/elasticsearch/jvm.options
echo ${elastic_password} | sudo /usr/share/elasticsearch/bin/elasticsearch-keystore -s add "bootstrap.password"
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service