provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "ecr" {
  name                 = "my-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "public_policy" {
  repository = aws_ecr_repository.ecr.name
  policy = jsonencode({
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "AllowPull",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:BatchGetImage"
        ]
      }
    ]
  })
}
