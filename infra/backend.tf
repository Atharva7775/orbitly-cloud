# State is split per environment with -backend-config=envs/<env>.backend.hcl.
terraform {
  backend "s3" {
    bucket         = "orbitly-terraform-state"
    region         = "us-east-1"
    dynamodb_table = "orbitly-terraform-locks"
    encrypt        = true
  }
}
