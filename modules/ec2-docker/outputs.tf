output "instance_ip" {
    description = "Public IP of the instance"
    value       = aws_instance.main_instance.public_ip
}