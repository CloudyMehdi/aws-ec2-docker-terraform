
#VPC creation
resource "aws_vpc" "main_vpc" {
    cidr_block = "192.168.0.0/24"
    instance_tenancy = "default"

    tags = {
        Name = var.project_name
    }
}


#Subnet creation
resource "aws_subnet" "main_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "192.168.0.0/26" #The project does not need multiple subnets, so we only create one.
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-subnet"
    }
    
}


#Internet Gateway creation
resource "aws_internet_gateway" "main_internet_gateway" {
    vpc_id = aws_vpc.main_vpc.id
    
    tags = {
        Name = "${var.project_name}-IG"
    }
}


#Route table creation
resource "aws_route_table" "main_route_table" {
    vpc_id = aws_vpc.main_vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_internet_gateway.id
    }

    tags = {
        Name = "${var.project_name}-route-table"
    }
}

resource "aws_route_table_association" "main_subnet_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}



#Security group creation
/*  Inbound :
        HTTP : to retrieve the web page
        SSH : in case you want to connect to the instance

    Outbound : 
        DNS and HTTPS : to download docker, and the needed image
*/
resource "aws_security_group" "allow_http_ssh_and_dns_https" {
    name        = "Hello-from-Mehdi-SG"
    description = "Allow HTTPS and SSH inbound traffic, and allow DNS and HTTPS outbound traffic"
    vpc_id      = aws_vpc.main_vpc.id 

    tags = {
        Name = "${var.project_name}-SG"
    }
}

#Rules creation (with the best practice)
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
    security_group_id   = aws_security_group.allow_http_ssh_and_dns_https.id 
    description         = "Allow HTTP inbound traffic"

    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id   = aws_security_group.allow_http_ssh_and_dns_https.id 
    description         = "Allow SSH inbound traffic"

    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_dns" {
    security_group_id   = aws_security_group.allow_http_ssh_and_dns_https.id 
    description         = "Allow DNS outbound traffic"

    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "udp"
    from_port   = 53
    to_port     = 53
}

resource "aws_vpc_security_group_egress_rule" "allow_https" {
    security_group_id   = aws_security_group.allow_http_ssh_and_dns_https.id 
    description         = "Allow HTTPS outbound traffic"

    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
}


#Instance creation
#Will automatically create an 8GB EBS volume
resource "aws_instance" "main_instance" {
    ami                     = var.ami
    instance_type           = var.instance_type
    subnet_id               = aws_subnet.main_subnet.id
    vpc_security_group_ids  = [aws_security_group.allow_http_ssh_and_dns_https.id]

    tags = {
        Name = var.project_name
    }

    user_data = "${file("${path.module}/user-data.sh")} ${var.docker_image}"
    #The user data needs the link to the docker image to run it.
    #We just concat the user data with the link here (in the variable), it allows us to change docker image if we want to.
}