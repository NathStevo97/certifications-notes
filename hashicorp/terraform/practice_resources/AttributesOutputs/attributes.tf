#Configure provider with authentication keys
provider "aws" {
  region     = "eu-west-2"
}
#Configure Elastic IP
resource "aws_eip" "lb" {
  vpc      = true
}
#Configure EIP output
output "eip" {
  value = aws_eip.lb.public_ip
}
#configure aws bucket resource
resource "aws_s3_bucket" "mys3" {
  bucket = "nathan-test-bucket-001"
}
#Configure aws bucket output
output "mys3bucket" {
  value = aws_s3_bucket.mys3.bucket_domain_name
}
