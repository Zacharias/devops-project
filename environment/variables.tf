
variable "aws_region" {
  description = "The AWS region to create resources in."
}

variable "s3_bucket_name" {
  description = "The AWS S3 bucket name."
}

variable "s3_bucket_env" {
  description = "The AWS S3 bucket environment name."
}

variable "hosted_zone" {
  description = "The hosted zone to be used."
}

variable "domain" {
  description = "The domain to be used."
}

variable "subdomain" {
  description = "The subdomain to be used."
}

variable "cache_default_ttl" {
  description = "Cloudfront's cache default time to live."
  default = 3600
}

variable "cache_max_ttl" {
  description = "Cloudfront's cache maximun time to live."
  default = 86400
}
