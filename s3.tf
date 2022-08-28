resource "aws_s3_bucket" "congobucket" {
  bucket = "congobucket"
  force_destroy = true
  depends_on = [
    aws_dynamodb_table.congo-dynamodb-table
  ]
  tags = {
    Name        = "Mybucket"
    Environment = "test"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.congobucket.id
  acl    = "public-read-write"
}