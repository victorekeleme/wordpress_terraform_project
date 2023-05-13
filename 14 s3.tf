resource "aws_s3_bucket" "wordpress_s3" {
  bucket = var.bucket

  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags = {
    Name        = "${local.project}-s3"
    Environment = local.env[0]
  }
}

resource "aws_s3_bucket_ownership_controls" "wordpress_s3_owner_ctrl" {
  bucket = aws_s3_bucket.wordpress_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "wordpress_s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.wordpress_s3_owner_ctrl]

  bucket = aws_s3_bucket.wordpress_s3.id
  acl    = "private"
}

