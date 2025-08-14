terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"   
}


provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "demo-aws_s3_bucket" {
  bucket = "demo-aws-unique-s3-bucket-3123"
}