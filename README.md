# EC2 Docker
## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [How to use](#how-to-use)
- [Documentation](#documentation)
- [Evolution](#evolution)
- [Conclusion](#conclusion)

## Introduction
This is a simple Terraform project that creates an EC2 instance on AWS and runs a Docker container on it.
The Docker image used is intentionally simple, in order to focus on the deployment and infrastructure aspects.

This project is not meant to demonstrate frontend skills, but rather infrastructure provisioning using **Terraform, AWS, and Docker**.

Only one module is used to keep the infrastructure easy to read while still demonstrating a basic level of factorization.
The project can be easily customized using a `tfvars` file. The provided example allows the infrastructure to remain **AWS Free Tier eligible**.

## Prerequisites
You first need to [install Terraform](https://developer.hashicorp.com/terraform/install).
This project was tested using **Terraform v1.14.3 on linux_amd64**.

Then, install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

You must configure your AWS account using the aws configure command.
(If you do not have an AWS account yet, you will need to create one.)

If you have multiple AWS profiles configured on your machine (aws configure list-profiles), you can select the one to use by running:

``export AWS_PROFILE=your_profile``

## How to use
First, create a file named `terraform.tfvars` and copy the contents of `terraform.tfvars.example` into it.
You may modify the values according to your needs.

Then, open a terminal and run:
``terraform init``

Next, run:
``terraform plan``

This step allows you to preview the changes that will be applied to your AWS account.
It is strongly recommended, as misconfigurations (such as provider or version issues) could otherwise result in unexpected resources being created and potentially generate costs.

Finally, if everything looks correct, run:
``terraform apply``

The deployment may take a short while. Once completed, the EC2 instance will still need some time to install Docker and download the Docker image.

The public IP address of the instance will be displayed in the terminal.
You can open it in a web browser **using HTTP (not HTTPS)**.

If the page takes a long time to load, the instance is likely still initializing. Simply wait a bit longer and try again.

## Documentation
No custom Network ACL is created. All filtering is handled by the security group.
A default Network ACL is automatically created when the VPC is provisioned.

The `terraform.tfvars` file is intentionally ignored to avoid committing a fixed execution context.

### ec2-docker module
This module creates:
- a VPC
- a subnet
- an internet gateway
- a route table
- a security group
- an EC2 instance

The EC2 instance hosts a Docker container and is accessible from the internet via HTTP.

The security group allows:

- inbound SSH and HTTP traffic (for instance access and web access)
- outbound DNS and HTTPS traffic (to install Docker and pull the Docker image)

#### Variables
- **project_name** (string): Name of the project. The VPC, subnet, internet gateway, route table, security group, and EC2 instance will share this name to distinguish them from other projects.
- **docker_image** (string): Path to the Docker image hosted on Docker Hub.
- **instance_type** (string): Type of EC2 instance to create (e.g. "t2.micro").
- **ami** (string): AMI ID used to launch the EC2 instance.

#### Outputs
- **instance_ip** (string): Public IPv4 address of the created EC2 instance.

#### User data
The user data script installs Docker on the EC2 instance and runs the Docker image specified by the `docker_image` variable.

The Docker image is not hardcoded inside the `user-data.sh` script.
Instead, it is passed as an argument from the module, making it easy to switch images without modifying the script itself.

### Main program
#### Variables
- **region** (string): AWS region where the infrastructure will be deployed (e.g. `"us-east-1"`).
- **docker_image** (string): Path to the Docker image hosted on Docker Hub.
- **instance_type** (string): Type of EC2 instance to create.
- **project_name** (string): Name shared by all created resources.

#### Data
- **amazon_linux_2023** (`aws_ami`): Latest available Amazon Linux 2023 AMI.

#### Outputs
- **ec2_public_ip** (string): Public IPv4 address of the EC2 instance.

### Docker project
The Docker image contains a very simple static web page that displays text entered by the user.
Its purpose is solely to provide a minimal application to deploy, keeping the focus on infrastructure and automation rather than application complexity.

## Evolution
- The project currently creates two security groups, including one that is unnecessary. This should be fixed.

- Add support for creating or selecting an existing EC2 key pair, allowing direct SSH access without relying on Instance Connect.

- Add support for multi-container deployments using Docker Compose.

## Conclusion
This project was created to demonstrate my motivation and technical interest in cloud computing.
Through this project, I learned how to deploy an application from scratch using Terraform and AWS, build a simple Docker image, and run it inside a container on EC2.