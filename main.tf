
variable "target_zone_name" {
  type        = string
  description = "The name of the zone that the recordsets are to be published into. This will be used to turn relative hostnames into absolute ones in the given recordsets."
}

variable "recordsets" {
  type = set(object({
    name    = string
    type    = string
    ttl     = number
    records = set(string)
  }))
  description = "The recordsets to normalize."
}

locals {
  # The record types whose values end with hostnames that might be relative
  # in the input, and which should be absolute in the output.
  hostname_value_types = toset(["NS", "CNAME", "DNAME", "MX", "SRV"])

  recordsets = toset([
    for rs in var.recordsets : (
      contains(["CNAME", "DNAME", "NS", "SRV", "MX", "PTR"], rs.type) ?
      merge(rs, {
        records = toset([
          for record in rs.records : replace(record, "/([^\\.])$/", "$1.${var.target_zone_name}.")
        ])
      }) :
      rs
    )
  ])
}

output "normalized" {
  value = local.recordsets
}
