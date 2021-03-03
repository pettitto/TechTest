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
