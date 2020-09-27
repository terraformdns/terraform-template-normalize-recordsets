# `terraformdns` recordset preprocessing module

This is an internal module of
[the `terraformdns` project](https://terraformdns.github.io/) which is
used by the project's other modules to preprocess incoming recordsets into
a consistent shape ready to be used to declare DNS recordset/record resources.

This module currently just deals with the problem of turning "relative" names
in the subset of DNS record types that include hostnames as part of their
value (`NS`, `CNAME`, `DNAME`, `MX`, `SRV`) into the absolute names that
underlying services tend to expect.

```hcl
module "normalize" {
  source = "terraformdns/normalize-recordsets/template"

  target_zone_name = "example.com"
  recordsets = [
    {
      name = "foo"
      type = "CNAME"
      ttl  = 300
      records = [
        "bar",
        "baz",
      ]
    },
  ]
}
```

With the above example, the module would produce the output value `normalized`
where the two `CNAME` records are rewritten to `bar.example.com.` and
`baz.example.com.` respectively.

The `terraformdns` project is focused on generic modelling of the most
commonly-used record types, so it may not gracefully handle other
less-commonly-used ones. The behavior of this normalization module might
change in future for record types that are not in the following list:

* `A`
* `AAAA`
* `NS`
* `CNAME`
* `DNAME`
* `MX`
* `SRV`
* `TXT`
