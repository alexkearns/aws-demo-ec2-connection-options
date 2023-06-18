locals {
  my_ip = data.http.ip.response_body
}
