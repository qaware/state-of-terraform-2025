##############################
# Check: Website Status
##############################
check "website_status_code" {
  data "http" "static_website" {
    url = local.website_endpoint
  }

  assert {
    condition     = data.http.static_website.status_code == 200
    error_message = "${data.http.static_website.url} returned an unhealthy status code"
  }
}