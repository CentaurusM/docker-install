#########################
### Install Docker ###

# SET UP THE REPOSITORY
# Update the apt package index:
apt-get update

# Install packages to allow apt to use a repository over HTTPS:
apt-get -y install  apt-transport-https \
                    ca-certificates \
                    curl \
                    software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

# Use the following command to set up the stable repository.
# You always need the stable repository, even if you want to install builds 
# from the edge or test repositories as well. To add the edge or test repository, 
# add the word edge or test (or both) after the word stable in the commands below.
# Note: The lsb_release -cs sub-command below returns the name of your Ubuntu distribution, 
# such as xenial. Sometimes, in a distribution like Linux Mint, you might need 
# to change $(lsb_release -cs) to your parent Ubuntu distribution. For example, 
# if you are using Linux Mint Rafaela, you could use trusty.

# x86_64 / amd64
# armhf
# IBM Power (ppc64le)
# IBM Z (s390x)

# add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) \
#   stable"
   
add-apt-repository \
    "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
   
# Update the apt package index:   
apt-get -y update

# List the versions available in your repo
# apt-cache madison docker-ce
# docker-ce | 18.03.0~ce-0~ubuntu | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages

# Install docker-ce
apt-get -y install docker-ce=18.06.0~ce~3-0~ubuntu


###############################
### Install Nvidia-docker ###

# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
