terraform {
  source = "../../modules/s3_static_site"
}

inputs = {
  bucket_name = "url-shortener-d3d9ex"
}
