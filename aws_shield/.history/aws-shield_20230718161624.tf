provider "aws" {
  region = "us-west-2"
}

# Define the Load Balancer ARN
variable "load_balancer_arn" {
  default = "arn:aws:elasticloadbalancing:us-west-2:678573427865:loadbalancer/net/a83f896ea302d4917abbda039ffb9c5b/b691184838475808"
}

# Create an AWS WAF WebACL
resource "aws_wafv2_web_acl" "web_acl" {
  name        = "MyWebACL"
  scope       = "REGIONAL" # Use "CLOUDFRONT" if you're using CloudFront, otherwise "REGIONAL" for load balancers
  description = "My Web ACL for Load Balancer"

  default_action {
    allow {}
  }
}

# Create a rule group for the AWS WAF rule
resource "aws_wafv2_rule_group" "rule_group" {
  name        = "MyRuleGroup"
  scope       = "REGIONAL"
  description = "My Rule Group for Load Balancer"

  capacity = 100

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "MyRuleGroupMetrics"
    sampled_requests_enabled   = true
  }
}

# Create an AWS WAF rule to include in the rule group
resource "aws_wafv2_rule" "rule" {
  name        = "MyWAFRule"
  scope       = "REGIONAL"
  description = "My WAF Rule for Load Balancer"

  action {
    block {}
  }

  statement {
    managed_rule_group_statement {
      name = "AWSManagedRulesCommonRuleSet"
      excluded_rule {
        name = "SizeRestrictions_QUERYSTRING"
      }
    }
  }
}

# Create an AWS WAFv2 web ACL association with the load balancer
resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = var.load_balancer_arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}

# Create an AWS WAFv2 rule group association with the web ACL
resource "aws_wafv2_web_acl_association" "rule_group_association" {
  resource_arn = aws_wafv2_web_acl.web_acl.arn
  web_acl_arn  = aws_wafv2_rule_group.rule_group.arn
}
