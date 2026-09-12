terraform {

  backend "s3" {

    bucket = "segun-phoenix-terraform-state"
    key    = "kubernetes/prod.tfstate"
    region = "us-east-1"

    use_lockfile = true

    encrypt = true

  }
}

