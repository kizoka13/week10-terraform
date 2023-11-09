terraform {
  backend "s3" {
    bucket         = "my-kizoka-bucket"
    key            = "week10/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "kizoka-table-lock"
  }
}