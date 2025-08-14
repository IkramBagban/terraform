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

resource "random_id" "rand_id" {
  byte_length = 8
}


resource "aws_s3_bucket" "demo-aws_s3_bucket" {
  bucket = "demo-aws-unique-s3-bucket-${random_id.rand_id.hex}"
}

resource "aws_s3_object" "bucket-data" {
    bucket = aws_s3_bucket.demo-aws_s3_bucket.bucket
    key    = "./data.txt"
    source = "data.txt"
}