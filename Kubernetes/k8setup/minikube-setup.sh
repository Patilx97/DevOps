#!/bin/bash

sudo apt update -y
sudo apt install docker.io -y
sudo service docker status
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

sudo chmod +x kubectl
mkdir -p ~/.local/bin
sudo mv ./kubectl ~/.local/bin/kubectl

# minikube installation
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
echo $PATH
export PATH=$PATH:/usr/local/bin
source ~/.bashrc
sudo usermod -aG docker $USER && newgrp docker
sudo apt-get install -y qemu-kvm libvirt-daemon libvirt-daemon-system
sudo usermod -aG libvirt $USER && newgrp libvirt
sudo apt-get install -y qemu qemu-kvm
sudo apt-get update -y
sudo apt-get install -y qemu-system-x86
