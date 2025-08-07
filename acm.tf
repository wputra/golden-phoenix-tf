resource "aws_acm_certificate" "this" {
  domain_name       = "deraque.store"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.deraque.store",
  ]

  lifecycle {
    create_before_destroy = true
  }
}
