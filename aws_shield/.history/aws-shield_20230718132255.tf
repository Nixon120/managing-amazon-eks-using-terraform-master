provider "aws" {
  region = "us-west-2"
}

resource "aws_shield_protection" "example" {
  resource_arn = "arn:aws:elasticloadbalancing:us-west-2:678573427865:loadbalancer/net/a83f896ea302d4917abbda039ffb9c5b/b691184838475808"

  # Block the specified IP
  mitigation_behaviors {
    type = "IP"
    address = "216.49.45.122"
  }
}
