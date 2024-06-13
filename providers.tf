provider "aws" {
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::2111-2567-4466:role/CrossAccountRole"
  }
}
