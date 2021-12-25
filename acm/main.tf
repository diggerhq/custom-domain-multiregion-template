
provider "aws" {
  alias = "aws"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.certificate_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

output "acm_certificate_record_type" {
  value = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
}

output "acm_certificate_record_name" {
  value = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
}

output "acm_certificate_record_value" {
  value = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}