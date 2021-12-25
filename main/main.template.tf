
terraform {
  required_version = ">= 0.12"

  # vars are not allowed in this block
  # see: https://github.com/hashicorp/terraform/issues/22088
  backend "s3" {}
}

{% for region in environment_config.regions %}

  provider "aws" {
    alias = "{{region}}"
    version = "= 3.70.0"
    region  = "{{region}}"
    access_key = var.aws_key
    secret_key = var.aws_secret
  }

{% endfor %}

{% for region in environment_config.regions %}

module "acm_{{region}}" {
  source = "../acm"
  providers = {
    aws = aws.{{region}}
  }
}

output "acm_certificate_record_type_{{region}}" {
  value = module.acm_{{region}}.acm_certificate_record_type
}

output "acm_certificate_record_name_{{region}}" {
  value = module.acm_{{region}}.acm_certificate_record_name
}

output "acm_certificate_record_value_{{region}}" {
  value = module.acm_{{region}}.acm_certificate_record_value
}

output "acm_certificate_arn_{{region}}" {
  value = module.acm_{{region}}.acm_certificate_arn
}

{% endfor %}
