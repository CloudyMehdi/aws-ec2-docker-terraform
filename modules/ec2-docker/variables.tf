variable "project_name" {
    description = "Name of the project. It will be the name of the instance, the VPC and so on..."
    type        = string
}

variable "docker_image" {
    description = "Path to the docker image on docker hub"
    type        = string
}

variable "instance_type" {
    description = "Type of the EC2 instance"
    type        = string
}

variable "ami" {
    description = "AMI ID for the EC2 instance"
    type        = string
}