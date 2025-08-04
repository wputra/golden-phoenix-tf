locals {
  container_port = 80
}

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
      image     = "docker.io/nginx:latest"
      portMappings = [
        {
          name          = "http"
          containerPort = local.container_port
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
  security_group_ingress_rules = {
    alb = {
      description                  = "Service port"
      from_port                    = local.container_port
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb.security_group_id
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  load_balancer = {
    service = {
      target_group_arn = aws_lb_target_group.app.arn
      container_name   = "app"
      container_port   = local.container_port
    }
  }
}
