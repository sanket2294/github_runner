provider "aws" {
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::211125674466:role/CrossAccountRole"
  }
}
