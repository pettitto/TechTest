variable "ami_value" {
  description = "Value of the AMI to be used"
  type        = string
  default     = "ami-0e999cbd62129e3b1"
}

variable "instance_type" {
  description = "Instance type to be used"
  type        = string
  default     = "t2.micro"
}

variable "ssh_user" {
  description = "SSH user name to use for remote exec connections,"
  type        = string
  default     = "ec2-user"
}

variable "ssh_port" {
  description = "The initial port the EC2 Instance should listen on for SSH requests."
  type        = number
  default     = 22
}

variable "secure_ssh_port" {
  description = "The port the EC2 Instance should listen on for SSH requests."
  type        = number
  default     = 5522
}
