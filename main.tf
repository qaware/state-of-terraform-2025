terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.85.0"
    }
  }
}

provider "aws" {
  region                      = "eu-north-1"
  access_key                  = "test" # Dummy access key for LocalStack
  secret_key                  = "test" # Dummy secret key for LocalStack
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3 = "http://localhost:4566" # LocalStack default port for S3
    # Uncomment and configure additional endpoints as needed:
    # ec2       = "http://localhost:4566"
    # iam       = "http://localhost:4566"
    # dynamodb  = "http://localhost:4566"
    # etc.
  }
}


##############################
# Resource: S3 Bucket for Static Website Hosting
##############################
resource "aws_s3_bucket" "static_site_bucket" {
  bucket = var.bucket_name
}

##############################
# Resource: Upload index.html to the S3 Bucket
##############################
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_site_bucket.bucket
  key          = var.website_index_object_key
  source       = "index.html"
  content_type = "text/html"
  acl          = "public-read"

  lifecycle {
    # For demo: recreate object when versioning behaviour changes, so version id reflects versioning status.
    replace_triggered_by = [aws_s3_bucket_versioning.versioning_configuration]

    postcondition {
      condition     = try(self.version_id != "null", false)
      error_message = "The index.html object must be versioned."
    }
  }
}

##############################
# Resource: S3 Bucket Website Configuration
##############################

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.static_site_bucket.id

  index_document {
    suffix = "index.html"
  }

  lifecycle {
    precondition {
      condition     = aws_s3_object.index_html.key == "index.html"
      error_message = "The object key of the index-object of the website must be 'index.html'."
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning_configuration" {
  bucket = aws_s3_bucket.static_site_bucket.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

##############################
# Resource: S3 Bucket Public Access Block
##############################
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site_bucket.id

  # Allow public ACLs and policies so our website can be read publicly.
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

##############################
# Resource: S3 Bucket Policy for Public Read Access
##############################
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.static_site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site_bucket.arn}/*"
      }
    ]
  })
}

##############################
# Output: Website Endpoint
##############################
output "website_endpoint" {
  description = "The endpoint for the static website hosted on S3."

  # This is for a website in "real" AWS:
  # value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint

  # For LocalStack the value is:
  value = "https://${aws_s3_bucket.static_site_bucket.bucket}.s3-website.localhost.localstack.cloud:4566/"
}
