run "content_uploaded_correctly" {
  command = apply

  variables {
    # Use unique bucket name in test to avoid conflicts with applied state. 
    bucket_name = "test-bucket"
  }

  # Check index.html hash matches
  # Note, that the etag is only available after the object is uploaded, so we can't check this on the plan output.
  assert {
    condition     = aws_s3_object.index_html.etag == filemd5("./index.html")
    error_message = "Content of index.html does not match (md5-hash mismatch)."
  }
}