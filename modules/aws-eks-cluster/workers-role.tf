
resource "aws_iam_role" "worker_node" {
  name = "${var.name}-${var.environment}-netsec-workers"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


data "aws_iam_policy_document" "custom_eks_worker_node" {
  // Customized EKSWorkerNodePolicy
  // https://console.aws.amazon.com/iam/home?#/policies/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy$jsonEditor
  statement {

    actions = [
      "ec2:DescribeVpcs",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DescribeVpcs",
      "eks:DescribeCluster"
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:Vpc"

      values = [
        var.vpc.arn,
      ]
    }
  }
}


data "aws_iam_policy_document" "custom_eks_cni" {
  // Customized AmazonEKS_CNI_Policy
  // https://console.aws.amazon.com/iam/home?#/policies/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy$jsonEditor
  statement {
    actions = [
      "ec2:CreateTags"
    ]
    resources = [
      "arn:aws:ec2:${var.region}:*:network-interface/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:Vpc"

      values = [
        var.vpc.arn,
      ]
    }
  }

  statement {
    actions = [
      "ec2:AssignPrivateIpAddresses",
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstanceTypes",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:UnassignPrivateIpAddresses"
    ]

    resources = [
      "*",
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:Vpc"

      values = [
        var.vpc.arn,
      ]
    }
  }
}

data "aws_iam_policy_document" "custom_ecr_readonly" {
  // Customized AmazonEC2ContainerRegistryReadOnly
  // https://console.aws.amazon.com/iam/home?#/policies/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly$jsonEditor
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]

    resources = [
      "arn:aws:ecr:${var.region}:*",
    ]
  }
}


resource "aws_iam_role_policy" "eks_worker_node" {
  name   = "${var.name}-${var.environment}-netsec-workers-policy"
  role   = aws_iam_role.worker_node.name
  policy = data.aws_iam_policy_document.custom_eks_worker_node.json
}

resource "aws_iam_role_policy" "custom_eks_cni" {
  name   = "${var.name}-${var.environment}-netsec-workers-policy"
  role   = aws_iam_role.worker_node.name
  policy = data.aws_iam_policy_document.custom_eks_cni.json
}

resource "aws_iam_role_policy" "custom_ecr_readonly" {
  name   = "${var.name}-${var.environment}-netsec-workers-policy"
  role   = aws_iam_role.worker_node.name
  policy = data.aws_iam_policy_document.custom_ecr_readonly.json
}
