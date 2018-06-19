data "aws_iam_policy_document" "role" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    effect = "Allow"
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid = ""

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}

# data "aws_iam_policy_document" "ecr_push_pull_policy" {
#   statement {
#     actions = []

#     principals {
#       type = "AWS"

#       identifiers = [
#         "${var.aws_account_id}",
#       ]
#     }
#   }
# }

# resource "aws_ecr_repository_policy" "push_pull" {
#   repository = "${aws_ecr_repository.default.name}"
#   policy     = "${data.aws_iam_policy_document.ecr_push_pull_policy.json}"
# }

resource "aws_iam_role" "default" {
  name               = "default"
  assume_role_policy = "${data.aws_iam_policy_document.role.json}"
}

resource "aws_iam_role_policy" "default" {
  role   = "${aws_iam_role.default.name}"
  policy = "${data.aws_iam_policy_document.permissions.json}"
}

resource "aws_codebuild_project" "default" {
  name         = "${var.name}"
  description  = "The ${var.name} CodeBuild Project"
  service_role = "${aws_iam_role.default.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    type            = "LINUX_CONTAINER"
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    privileged_mode = true

    environment_variable {
      "name"  = "AWS_DEFAULT_REGION"
      "value" = "${var.aws_region}"
    }

    environment_variable {
      "name"  = "AWS_ACCOUNT_ID"
      "value" = "${var.aws_account_id}"
    }

    environment_variable {
      "name"  = "IMAGE_REPO_NAME"
      "value" = "${var.ecr_image_repo_name}"
    }

    environment_variable {
      "name"  = "IMAGE_TAG"
      "value" = "latest"
    }
  }

  source {
    type            = "GITHUB"
    location        = "${var.github_repo_url}"
    git_clone_depth = 1
  }
}
