provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"

  default_tags {
    tags = {
      Environment = terraform.workspace
      Terraform   = "true"
    }
  }
}
