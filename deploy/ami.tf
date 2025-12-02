data "aws_ami" "zbr_linux" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["Zebrunner-ESG-Agent-Light-*"]
  }
  filter {
    name   = "block-device-mapping.device-name"
    values = ["/dev/xvda"]
  }
}

data "aws_ami" "ubuntu_22_04" {
  most_recent = true

  # Amazon
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "local_file" "ami_info" {
  filename = "${path.module}/ami_info.txt"
  content = jsonencode({
    e3s_server_ami_id      = data.aws_ami.ubuntu_22_04.id
    e3s_server_ami_name    = data.aws_ami.ubuntu_22_04.name
    e3s_server_ami_date    = data.aws_ami.ubuntu_22_04.creation_date
    esg_worker_node_ami_id       = data.aws_ami.zbr_linux.id
    esg_worker_node_ami_name     = data.aws_ami.zbr_linux.name
    esg_worker_node_ami_date     = data.aws_ami.zbr_linux.creation_date
  })
}
