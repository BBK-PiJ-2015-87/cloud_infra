provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "london" {
  count                 = 0
  ami                   = "ami-9c363cf8"      #Red Hat Enterprise Linux 7.3
  instance_type         = "t2.micro"
  security_groups       = ["in_ssh_http", "out_ssh_http"]
  availability_zone     = "eu-west-2a"
  key_name              = "dev-london"        #was created manually in aws console prior
  iam_instance_profile  = "read_s3"           #created in aws console

  provisioner "file" {
    source      = "files/init.sh"
    destination = "/tmp/init.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.ssh/dev-london.pem")}"
    }
  }

  provisioner "file" {
    source      = "files/install_nginx.yml"
    destination = "/tmp/install_nginx.yml"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.ssh/dev-london.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "sudo bash -x /tmp/init.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("~/.ssh/dev-london.pem")}"
    }
  }
}