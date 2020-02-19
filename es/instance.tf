resource "aws_instance" "es_ec2" {
  count                        = var.node_count
  ami                          = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address  = var.associate_public_ip_address_instance
  availability_zone            = var.es_az
  instance_type                = var.instance_type
  key_name                     = var.key_name
  monitoring                   = var.monitoring
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_es.id, aws_default_security_group.default.id]
  subnet_id                    = aws_subnet.public_subnet.id
  tags                         = var.es_tags
  tenancy                      = "default"

  user_data               = data.template_file.user_data.rendered
  root_block_device {
    delete_on_termination = true 
    encrypted             = false 
    iops                  = 100     
    volume_size           = 8 
    volume_type           = "gp2"
  }
}

data "template_file" "user_data" {
  template = file("user_data.sh")

  vars = {
    elastic_password = var.elastic_password
    cert_data = filebase64(var.cert_file_path)
    cert_file_passwd = var.cert_file_passwd
  }
}

resource "aws_ebs_volume" "es_data" {
  count             = var.node_count
  availability_zone = var.es_az
  size              = var.es_data_disk_size
  type              = "gp2"
  tags              = var.es_tags
}

resource "aws_volume_attachment" "ebs_data_attachment" {
  count       = var.node_count
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.es_data[count.index].id
  instance_id = aws_instance.es_ec2[count.index].id
  skip_destroy = true
  force_detach = true
}
