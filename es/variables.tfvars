location  = "us-east-2"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.5.0/24"
enable_dns_hostnames = true
map_public_ip_on_launch = true
es_az = "us-east-2b"
monitoring = false
vpc_tags = {
    Name = "es-vpc"
    }
es_tags = {
    Name = "es-cluster"
}    
node_count = 2
es_data_disk_size = 2
associate_public_ip_address_instance = true
instance_type = "t2.small"
key_name = "es-ec2"