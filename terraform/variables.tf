variable "prefix" {
  description = "A prefix used for naming resources."
}

variable "tags" {
  type = "map"

  default = {
    Name = "default"
  }
}

variable "ecr_repo_name" {
  description = "The name of the Docker repository in ECR"
  type        = "string"
}

variable "container_image_sha256" {
  description = "The sha256 hash of the pushed container image."
  type        = "string"
}

variable "github_repo_url" {
  description = "The url to the source code repository in GitHub"
}

variable "aws_account_id" {
  description = "Your AWS account ID"
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-1"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "app_port" {
  description = "The TCP port the app listens on."
  default     = "8080"
}

variable "az_count" {
  description = "The number of availability zones wanted."
  default     = 3
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC"
  default     = "10.0.0.0/20"
}

variable "private_subnets" {
  type    = "list"
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type    = "list"
  default = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
}
