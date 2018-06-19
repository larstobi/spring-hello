variable "aws_account_id" {
  description = "Your AWS account ID"
}

variable "aws_region" {
  description = "The AWS region to create things in."
}

variable "name" {
  description = "The name of the codebuild project."
}

variable "github_repo_url" {
  description = "The url to the source code repository in GitHub"
}

variable "ecr_image_repo_name" {
  description = "The name of the ECR repo."
}
