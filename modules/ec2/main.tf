resource "aws_instance" "runner" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  tags = var.tags

  user_data = var.user_data
}
