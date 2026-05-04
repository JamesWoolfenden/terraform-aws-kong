data "aws_iam_policy_document" "kong-ssm" {
  # checkov:skip=CKV_AWS_356: IAM policy requires broad access for this module to function
  statement {
    actions   = ["ssm:DescribeParameters"]
    resources = ["*"]
  }

  statement {
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:*:*:parameter/${var.service}/${var.environment}/*"]
  }

  statement {
    actions   = ["kms:Decrypt"]
    resources = [aws_kms_alias.kong.target_key_arn]
  }
}
resource "aws_iam_role_policy" "kong-ssm" {
  # checkov:skip=CKV_AWS_290: Policy requires broad access for this module to function
  # checkov:skip=CKV_AWS_355: Policy requires broad access for this module to function
  name = format("%s-%s-ssm", var.service, var.environment)
  role = aws_iam_role.kong.id

  policy = data.aws_iam_policy_document.kong-ssm.json
}
data "aws_iam_policy_document" "kong" {
  # checkov:skip=CKV_AWS_356: IAM policy requires broad access for this module to function
  # checkov:skip=CKV_AWS_290: IAM policy requires broad write access for this module to function
  # checkov:skip=CKV_AWS_355: IAM policy requires wildcard resource for this module to function
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "kong" {
  name               = format("%s-%s", var.service, var.environment)
  assume_role_policy = data.aws_iam_policy_document.kong.json
}
resource "aws_iam_instance_profile" "kong" {
  name = format("%s-%s", var.service, var.environment)
  role = aws_iam_role.kong.id
}
