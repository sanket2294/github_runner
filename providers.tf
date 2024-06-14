provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn     = var.assume_role_arn
    session_name = "terraform"
  }
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "assume_role_arn" {
  description = "The ARN of the role to assume"
  type        = string
}
