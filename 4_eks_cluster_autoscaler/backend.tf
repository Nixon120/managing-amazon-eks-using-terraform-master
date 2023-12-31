terraform {
  backend "s3" {
    bucket  = "hands-on-cloud-terraform-remote-state120-s3"
    key     = "managing-eks-terraform-eks-cluster-autoscaler.tfstate"
    region  = "us-west-2"
    encrypt = "true"
    dynamodb_table = "hands-on-cloud-terraform-remote-state-dynamodb"
  }
}
