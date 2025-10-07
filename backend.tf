terraform {
  backend "s3" {
    ## homework:start
    bucket = "miprimerterrabucketmaria"
    key = "ec2\terraform.tfstate"
    region = "us-west-1"
    ## homework:end
    # use_lockfile = true
    encrypt    = true
    kms_key_id = "a706e211-659a-4c40-b368-88033573f8f7"
  }
}
