provider "aws" {
  region = var.aws_region
}

# Create IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the necessary policies to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"  # Adjust based on the necessary permissions
}

module "ec2_github_runner" {
  source = "./modules/ec2"

  ami           = var.runner_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_id        = var.vpc_id

  tags = {
    Name = "GitHub-Runner"
  }

  user_data = <<-EOF
    #!/bin/bash

    # Variables for debugging
    echo "GITHUB_OWNER: ${var.github_owner}"
    echo "GITHUB_REPO: ${var.github_repo}"
    echo "GITHUB_TOKEN: ${var.github_token}"

    # Update and install necessary packages
    sudo apt-get update
    sudo apt-get install -y curl jq libicu-dev libssl3

    # Download and install GitHub runner
    mkdir actions-runner && cd actions-runner
    curl -o actions-runner-linux-x64-2.285.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.285.0/actions-runner-linux-x64-2.285.0.tar.gz
    tar xzf ./actions-runner-linux-x64-2.285.0.tar.gz

    # Configure SSL
    sudo ln -sf /lib/x86_64-linux-gnu/libssl.so.3 /usr/lib/x86_64-linux-gnu/libssl.so
    sudo ln -sf /lib/x86_64-linux-gnu/libcrypto.so.3 /usr/lib/x86_64-linux-gnu/libcrypto.so

    # Ensure system time is synchronized
    sudo timedatectl set-ntp true
    
    # Export necessary environment variables
    export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:\$LD_LIBRARY_PATH
    export DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER=0
    
    # Configure the runner
    ./config.sh --url https://github.com/${var.github_owner}/${var.github_repo} --token ${var.github_token}

    # Install the service
    sudo ./svc.sh install
    sudo ./svc.sh start
  EOF
}
