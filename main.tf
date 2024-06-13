module "ec2_github_runner" {
  source = "./modules/ec2"

  ami           = var.runner_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id

  tags = {
    Name = "GitHub-Runner"
  }

  user_data = templatefile("bootstrap.sh.tpl", {
    github_owner = var.github_owner,
    github_repo  = var.github_repo,
    github_token = var.github_token
  })
}
