resource "aws_iam_policy" "policy" {
  name        = "aws_secret_manager_for_ec2_for_roboshop_${var.ENV}"
  path        = "/"
  description = "IAM Policy for Secret Manager to Get the secrets by EC2 Instance - DEV Env"

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
