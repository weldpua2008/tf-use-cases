#!/bin/bash

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - || \
  curl -fsSL https://apt.releases.hashicorp.com/gpg |  apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" || \
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update || apt-get update  
sudo apt-get install terraform ||  apt-get install terraform
