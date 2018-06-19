provider "aws" {
  version = "1.23.0"
  region  = "${var.aws_region}"
}

module "ecr" {
  source           = "github.com/TeliaSoneraNorge/telia-terraform-modules//ecr?ref=2018.06.18.1"
  trusted_accounts = ["${var.aws_account_id}"]
  repo_name        = "${var.ecr_repo_name}"
}

# output "repository_url" {
#   value = "${data.aws_ecr_repository.default.repository_url}"
# }

module "build" {
  source              = "modules/build"
  aws_region          = "${var.aws_region}"
  aws_account_id      = "${var.aws_account_id}"
  name                = "${var.ecr_repo_name}"
  github_repo_url     = "${var.github_repo_url}"
  ecr_image_repo_name = "${var.ecr_repo_name}"
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}

module "vpc" {
  source               = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v1.34.0"
  name                 = "default"
  cidr                 = "${var.vpc_cidr}"
  azs                  = "${slice(data.aws_availability_zones.available.names, 0, var.az_count - 1)}"
  private_subnets      = "${slice(var.private_subnets, 0, var.az_count - 1)}"
  public_subnets       = "${slice(var.public_subnets, 0, var.az_count - 1)}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
}

resource "aws_ecs_cluster" "default" {
  name = "${var.prefix}-cluster"
}

# ------------------------------------------------------------------------------
# Create the external ALB
# ------------------------------------------------------------------------------
module "alb" {
  source     = "github.com/TeliaSoneraNorge/telia-terraform-modules//ec2/lb?ref=2018.06.18.1"
  prefix     = "${var.prefix}"
  type       = "application"
  internal   = "false"
  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = ["${module.vpc.public_subnets}"]
  tags       = "${var.tags}"
}

resource "aws_lb_listener" "fargate" {
  load_balancer_arn = "${module.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${module.service.target_group_arn}"
    type             = "forward"
  }
}

# ------------------------------------------------------------------------------
# Create the service
# # ------------------------------------------------------------------------------
module "service" {
  source = "github.com/TeliaSoneraNorge/telia-terraform-modules//ecs/fargate?ref=2018.06.18.1"

  prefix     = "${var.prefix}-service"
  vpc_id     = "${module.vpc.vpc_id}"
  cluster_id = "${aws_ecs_cluster.default.id}"

  task_container_port               = "8080"
  task_container_count              = "1"
  task_definition_image             = "${module.ecr.container_repo_repository_url}@sha256:${var.container_image_sha256}"
  task_definition_cpu               = "256"
  task_definition_ram               = "512"
  task_definition_environment_count = "1"

  task_definition_environment = {
    "NAME" = "test"
  }

  private_subnet_ids = "${module.vpc.private_subnets}"
  lb_arn             = "${module.alb.arn}"

  health_check {
    port = "traffic-port"
    path = "/actuator/health"

    # path    = "/actuator/health"
    matcher = "200"
  }

  tags = "${var.tags}"
}

resource "aws_security_group_rule" "task_ingress_8080" {
  security_group_id        = "${module.service.service_sg_id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "8080"
  to_port                  = "8080"
  source_security_group_id = "${module.alb.security_group_id}"
}

resource "aws_security_group_rule" "alb_ingress_80" {
  security_group_id = "${module.alb.security_group_id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = "80"
  to_port           = "80"
  cidr_blocks       = ["0.0.0.0/0"]
}
