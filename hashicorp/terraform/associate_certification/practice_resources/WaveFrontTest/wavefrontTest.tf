provider "wavefront" {
  address = "https://YOUR_CLUSTER.wavefront.com"
  token = "YOUR_API_TOKEN"
}

resource "wavefront_alert" "test_alert" {
  name = "Terraform Test Alert"
  target = "test@example.com"
  condition = "100 - ts(\"cpu.usage_idle\") > 80"
  display_expression = "100-ts(\"cpu.usage_idle\")"
  minutes = 5
  resolve_after_minutes = 5
  severity = "WARN"
  tags = [
    "terraform"
  ]
}