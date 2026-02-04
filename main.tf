
provider "aws" {
    region = var.region
}


#Instance creation with all needed arguments
module "ec2_docker" {
    source = "./modules/ec2-docker"

    docker_image    = var.docker_image
    ami             = data.aws_ami.amazon_linux_2023.id
    instance_type   = var.instance_type
    project_name    = var.project_name
}

