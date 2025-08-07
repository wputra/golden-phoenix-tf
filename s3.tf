module "lb_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "golden-phoenix-lb-logs"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true  # Required for ALB/NLB logs
}
