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

module "app_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "golden-phoenix-app"
  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 4096

  subnet_ids = module.vpc.private_subnets

  create_task_definition = false
  task_definition_arn   = 
}
