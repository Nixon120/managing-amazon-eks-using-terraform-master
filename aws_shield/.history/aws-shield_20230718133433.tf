provider "aws" {
  region = "us-west-2"
}

resource "aws_wafv2_web_acl" "example" {
  name        = "shield-and-waf-web-acl"
  description = "AWS WAF Web ACL for Shield Protection"

  scope = "REGIONAL" # Use "CLOUDFRONT" for global scope

  visibility_config {
    cloudwatch_metrics_enabled = false # Change to true if you want CloudWatch metrics
    metric_name                 = "WAFWebACLVisibility" # Metric name for CloudWatch
    sampled_requests_enabled    = false # Change to true if you want to sample requests for logging
  }

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

    visibility_config {
      cloudwatch_metrics_enabled = false # Change to true if you want CloudWatch metrics for this rule
      metric_name                 = "WAFBlockIPRuleVisibility" # Metric name for CloudWatch for this rule
      sampled_requests_enabled    = false # Change to true if you want to sample requests for this rule
    }
  }
}

resource "aws_wafv2_ip_set" "example" {
  name        = "blocked-ip-set"
  description = "IP set to block specified IP addresses"
  scope       = "REGIONAL" # Use "CLOUDFRONT" for global scope

  ip_address_version = "IPV4"
  addresses          = ["216.49.45.122/32"] # Convert the IP address to CIDR notation

  tags = {
    Name = "BlockedIPSet"
  }
}

resource "aws_wafv2_web_acl_association" "example" {
  web_acl_arn = aws_wafv2_web_acl.example.arn

  resource_arn = "arn:aws:elasticloadbalancing:us-west-2:678573427865:loadbalancer/net/a83f896ea302d4917abbda039ffb9c5b/b691184838475808"
}
