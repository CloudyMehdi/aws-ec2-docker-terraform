variable "region" {
  description = "Name of the region for the project"
  type = string
}

variable "docker_image" {
  description = "Link to the docker image that will be executed"
  type = string
}

variable "instance_type" {
  description = "Type for the EC2 instance that will be launched"
  type = string
}

variable "project_name" {
  description = "name of the project. The EC2 instance, VPC etc will have this name"
  type = string
}