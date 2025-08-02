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

  cpu    = 512
  memory = 2048

  # Container definition(s)
  container_definitions = {
    app = {
      essential = true
      image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
      portMappings = [
        {
          name          = "http"
          containerPort = 80
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonlyRootFilesystem = false
      memoryReservation      = 100

      restartPolicy = {
        enabled = true
        ignoredExitCodes = [1]
        restartAttemptPeriod = 60
      }
    }
  }

  subnet_ids = module.vpc.private_subnets
}
