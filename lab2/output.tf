output "ec2-public-id" {
    value = aws_instance.lab2tf-ec2-terraform.public_ip
}

output "ec2-private-id" {
    value = aws_instance.lab2tf-ec2-terraform.private_ip
}