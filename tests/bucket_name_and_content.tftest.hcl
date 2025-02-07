run "bucket_name_and_content" {
  command = plan

  variables {
    bucket_name = "test-bucket"
  }

  # Check that the bucket name is correct
  assert {
    condition     = aws_s3_bucket.static_site_bucket.bucket == "test-bucket"
    error_message = "Bucket name does not match input variable."
  }

  # Check index.html hash matches
  assert {
    condition     = aws_s3_object.index_html.etag == filemd5("./index.html")
    error_message = "Content of index.html does not match (md5-hash mismatch)."
  }
}