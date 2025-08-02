module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  name = "golden-phoenix-ecs"

  default_capacity_provider_strategy = {
    FARGATE = {
      base   = 3
      weight = 100
    }
  }
}
