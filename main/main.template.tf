
terraform {
  required_version = ">= 0.12"

  # vars are not allowed in this block
  # see: https://github.com/hashicorp/terraform/issues/22088
  backend "s3" {}
}

{% for region in environment_config.regions %}

  provider "aws" {
    alias = "{{region}}"
    version = "= 3.45.0"
    region  = "{{region}}"
    # profile = var.aws_profile
    access_key = var.aws_key
    secret_key = var.aws_secret
  }

  resource "aws_acm_certificate" "cert_{{region}}" {
    provider = aws.{{region}}
    domain_name       = var.certificate_domain
    validation_method = "DNS"

    lifecycle {
      create_before_destroy = true
    }
  }

  output "acm_certificate_record_type_{{region}}" {
    value = tolist(aws_acm_certificate.cert_{{environment_config.region}}.domain_validation_options)[0].resource_record_type
  }

  output "acm_certificate_record_name_{{region}}" {
    value = tolist(aws_acm_certificate.cert_{{environment_config.region}}.domain_validation_options)[0].resource_record_name
  }

  output "acm_certificate_record_value_{{region}}" {
    value = tolist(aws_acm_certificate.cert_{{environment_config.region}}.domain_validation_options)[0].resource_record_value
  }

  output "acm_certificate_arn_{{region}}" {
    value = aws_acm_certificate.cert_{{environment_config.region}}.arn
  }

{% endfor %}
