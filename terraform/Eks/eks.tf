resource "aws_iam_role" "eks" {
  name = "eks"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon-eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_eks_cluster" "eks" {
  name     = "eks"
  role_arn = aws_iam_role.eks.arn

  version = "1.29"

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = false
    subnet_ids = [
      aws_subnet.public_subnet1.id,
      aws_subnet.public_subnet2.id,
      aws_subnet.private_subnet1.id,
      aws_subnet.private_subnet2.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]
}