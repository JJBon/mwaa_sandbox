resource "aws_s3_bucket" "s3_bucket" {

  bucket =  var.airflow_dags_bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  force_destroy = true

  tags = merge(local.tags, {
    Name = var.prefix
  })
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "dags" {
  for_each = fileset("${path.module}/../airflow-docker/dags/", "*.py")
  bucket   = aws_s3_bucket.s3_bucket.id
  key      = "dags/${each.value}"
  source   = "${path.module}/../airflow-docker/dags/${each.value}"
  etag     = filemd5("${path.module}/../airflow-docker/dags/${each.value}")
}

resource "aws_s3_bucket_object" "utils" {
  for_each = fileset("${path.module}/../airflow-docker/dags/utils", "*.py")
  bucket   = aws_s3_bucket.s3_bucket.id
  key      = "dags/utils/${each.value}"
  source   = "${path.module}/../airflow-docker/dags/utils/${each.value}"
  etag     = filemd5("${path.module}/../airflow-docker/dags/utils/${each.value}")
}

resource "aws_s3_bucket_object" "requirements" {
  bucket   = aws_s3_bucket.s3_bucket.id
  key      = "requirements.txt"
  source   = "${path.module}/../airflow-docker/requirements.txt"
  etag     = filemd5("${path.module}/../airflow-docker/requirements.txt")
}