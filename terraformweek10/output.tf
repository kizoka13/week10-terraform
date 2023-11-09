output "SSHCommandEc2One" {
  value = "ssh -i week10keypair.pem ec2-user@${aws_instance.ec2-one.public_ip}"
  description = "SSH command for ec2-one"
}

output "SSHCommandEc2Two" {
  value = "ssh -i week10keypair.pem ec2-user@${aws_instance.ec2-two.public_ip}"
  description = "SSH command for ec2-two"
}

output "PublicIPEc2One" {
  value = aws_instance.ec2-one.public_ip
  description = "Public IP for ec2-one"
  depends_on = [aws_instance.ec2-one]
}

output "PublicIPEc2Two" {
  value = aws_instance.ec2-two.public_ip
  description = "Public IP for ec2-two"
  depends_on = [aws_instance.ec2-two]
}