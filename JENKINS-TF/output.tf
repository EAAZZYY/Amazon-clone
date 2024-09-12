output "jenkins_public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "The public IP address of the EC2 instance."
}

output "monitoring_public_ip" {
  value       = aws_instance.monitoring.public_ip
  description = "The public IP address of the EC2 instance."
}