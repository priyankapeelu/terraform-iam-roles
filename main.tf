resource "aws_iam_policy" "policy" {
  name        = "aws_secret_manager_for_ec2_for_roboshop_${var.ENV}"
  path        = "/"
  description = "IAM Policy for Secret Manager to Get the secrets by EC2 Instance - ${var.ENV} Env"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource" : [
          data.aws_secretsmanager_secret.secrets.arn
        ]
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:ListSecrets"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role_for_${var.ENV}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "ec2_role_for_${var.ENV}"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "documentdb-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDocDBReadOnlyAccess"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.ENV}_instance_profile"
  role = aws_iam_role.ec2_role.name
}


