variable "path_to_linux_key" {
  default     = "/home/ec2-user/environment/secret/mykey.pub"
  description = "Path to the public key to use in Linux VMs provisioning"
  type        = string
}

variable "instance_type" {
  default     = "t2.micro"  # Updated to t3.small
  description = "Instance type to use"
  type        = string
}
