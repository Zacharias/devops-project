resource "aws_cloudfront_distribution" "site" {
  enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = "${aws_s3_bucket.site.bucket_domain_name}"
    origin_id   = "${var.s3_bucket_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  #this was plan b to enable ssl.
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code    = 403
    response_code = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code    = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  # Route53 requires Alias/CNAME to be setup
  aliases = ["${var.s3_bucket_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.s3_bucket_name}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = "${var.cache_default_ttl}"
    max_ttl                = "${var.cache_max_ttl}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

#this is a fun redirection here.
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Origin Access Identity for S3"
}

data "aws_route53_zone" "primary" {
  name = "${var.hosted_zone}"
}
