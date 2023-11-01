output "ssh-command" {
  value = "ssh -i keyweek10.pem ec2-user@${aws_instance.ec2-one.public_dns}"
}

output "public-ip" {
  value = "${aws_instance.ec2-one.public_ip}"
}