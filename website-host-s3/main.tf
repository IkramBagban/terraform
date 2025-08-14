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


resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-static-site-${random_id.rand_id.hex}"
}



# Enables website hosting on the S3 bucket.
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  # The "index_document" block tells S3 which file to serve as the homepage.
  index_document { // Index document configuration, which means this document will be served as the homepage
    suffix = "index.html"
  }
}

# This resource disables blocking public access for the bucket (needed for a public website).
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# Defines a policy that allows anyone (public) to read files from the bucket.
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# Uploads index.html file to the bucket
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"
}

# Uploads style.css file to the bucket
resource "aws_s3_object" "styles" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "style.css"
  source       = "./style.css"
  content_type = "text/css"
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}