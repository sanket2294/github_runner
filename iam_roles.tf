resource "aws_iam_role" "cross_account_role" {
  name = "GitHubRunnerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::<AWS_ACCOUNT_ID>:root"
        }
      }
    ]
  })

  tags = {
    Name = "GitHubRunnerRole"
  }
}

resource "aws_iam_policy" "cross_account_policy" {
  name        = "GitHubRunnerPolicy"
  description = "Policy to allow GitHub runner to deploy resources in other accounts"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:*",
          "s3:*",
          "lambda:*",
          "rds:*",
          "cloudformation:*",
          "iam:PassRole"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.cross_account_policy.arn
}
