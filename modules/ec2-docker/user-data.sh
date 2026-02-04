#!/bin/bash

#Install and start docker
dnf update -y
dnf install -y docker

systemctl start docker

#Will not run docker right now, need the path to an image
docker run -dp 80:80