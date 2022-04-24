resource "aws_iam_role" "emr_jobs_role" {
  # Using a prefix ensures a unique name
  name = "emr-jobs-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "elasticmapreduce.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = local.tags
}

data "aws_iam_policy_document" "iam_policy_document_emr" {
 statement {
    sid = ""
    actions = [
      "s3:*"
    ]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    sid = ""
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    effect = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }

}

resource "aws_iam_policy" "iam_policy_emr" {
  name   = "eks_emr_jobs_policies"
  path   = "/"
  policy = data.aws_iam_policy_document.iam_policy_document_emr.json

}

resource "aws_iam_role_policy_attachment" "emr_job_role_policy_attachment" {
  role       = aws_iam_role.emr_jobs_role.name
  policy_arn = aws_iam_policy.iam_policy_emr.arn
}