output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.vpc.arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public-subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.public_subnet.id
}

output "public-subnet_arn" {
  description = "The ARN of the VPC"
  value       = aws_subnet.public_subnet.arn
}

output "instance_arn" {
  description = "The IDs of the VPC  "
  value       = aws_instance.es_ec2[*].arn
}

output "instance_id" {
  description = "The ARN of the instances"
  value       = aws_instance.es_ec2[*].id
}

output "instance_pubic_ip" {
  description = "The public ip assigned to instance"
  value       = aws_instance.es_ec2[*].public_ip 
}

output "instance_private_ip" {
  description = "The private ip assigned to instance"
  value       = aws_instance.es_ec2[*].private_ip 
}

output "instance_pubic_dns" {
  description = "The public dns assigned to instance"
  value       = aws_instance.es_ec2[*].public_dns
}

output "instance_private_dns" {
  description = "The private dns assigned to instance"
  value       = aws_instance.es_ec2[*].private_dns
}

output "aws_route_table_id" {
  description = "The ARN of the aws_route_table"
  value       = aws_route_table.public_route_table.id
}

output "aws_route_table_association_id" {
  description = "The ARN of the aws_route_table"
  value       = aws_route_table_association.public_route_table_association.id
}

output "aws_data_disk_arn" {
  description = "The arn of additional disk mounted to store es data"
  value       = aws_ebs_volume.es_data[*].arn
}