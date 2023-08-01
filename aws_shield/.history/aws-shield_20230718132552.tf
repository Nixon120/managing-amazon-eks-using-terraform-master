provider "aws" {
  region = "us-west-2"
}

resource "aws_wafv2_web_acl" "example" {
  name        = "shield-and-waf-web-acl"
  description = "AWS WAF Web ACL for Shield Protection"

  scope = "REGIONAL" # Use "CLOUDFRONT" for global scope

  default_action {
    block {}
  }

  rule {
    name     = "BlockIPRule"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.example.arn
      }
    }
  }
}

resource "aws_wafv2_ip_set" "example" {
  name        = "blocked-ip-set"
  description = "IP set to block specified IP addresses"
  scope       = "REGIONAL" # Use "CLOUDFRONT" for global scope

  ip_address_version = "IPV4"
  addresses          = ["216.49.45.122"]
}
