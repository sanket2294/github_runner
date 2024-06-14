variable "ami" {
  description = "AMI ID for the GitHub runner"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the instance"
  type        = map(string)
}

variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
}
