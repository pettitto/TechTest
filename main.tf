terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "TechTest" {
  ami                         = "ami-0e999cbd62129e3b1"
  instance_type               = "t2.micro"
  security_groups             = ["access-controls"]
  count                       = 1
  associate_public_ip_address = true
  key_name                    = "ssh-key"

  vpc_security_group_ids = [
    aws_security_group.access-controls.id
  ]

}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqr1aEWMbI+xONdv/ezM7c4TK3BUWq+2E8OpTVbkeu2l6hOx+5WgilJezwHOtduJhrfHAktHbPVgo2KCe659w7/mXjZWY90qOZnzP+EXa75f4jAG0nNJ+co4482FfAcG4R/QpVeVMcIeXE3Cy2qS0gKpK70malmTXAKowpcu/uy/4uX8gezKR++aTBWPUeNE9mtDDuw+u2Mk7wRfaqVSPha9dmU6dSLL0pJiNHvnSqL676GxeIHivQSVV9s1hJ90p9z6vazDHT90wiFD2vkgo0XKZR77pZRtkeOtBs3VLggj2cKaujmk3/1ERlIcfxvw9ghHNKUDTfaak/3iNFj2/D7O2HcqygTqpfn9XaMZJ7cufv6xD5fgHuOFHeaGhoS8Akiikws2h88ijIZ1lj58J7r7MnArbNnno8nr6XfozVaQ2l2fXwjV23e8ukNEYY9eSqOTIquSCTZZyM0HaLivrU9l7V86Ef+skohf3sZysJX65cy4fk6HJmq9YQHMO8Oh0= chris@chris.local"
}

resource "aws_security_group" "access-controls" {
  name        = "access-controls"
  description = "Access Controls for SSH and Netdata"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 19999
    to_port     = 19999
    protocol    = "tcp"
    description = "Netdata"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
