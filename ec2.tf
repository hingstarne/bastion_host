resource "aws_instance" "bastion_host" {
  ami                         = "ami-f9dd458a"
  availability_zone           = "eu-west-1a"
  ebs_optimized               = false
  instance_type               = "t2.nano"
  monitoring                  = false
  key_name                    = "aws-ec2-henry"
  subnet_id                   = "subnet-11bb2948"
  vpc_security_group_ids      = ["sg-884e8dec"]
  associate_public_ip_address = true
  disable_api_termination     = true
  source_dest_check           = false
  user_data = "${template_file.bastion_cloud_config.rendered}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    iops                  = 24
    delete_on_termination = false
  }

  tags {
    "Name"              = "bastion_host"
    "Environment"       = "production"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "template_file" "bastion_cloud_config" {
    template = "${file("user-data/bastion")}"
}