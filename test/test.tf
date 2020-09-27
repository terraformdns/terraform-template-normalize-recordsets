module "tested" {
  source = "../"

  target_zone_name = "example.com"
  recordsets = [
    {
      name = "foo"
      type = "CNAME"
      ttl  = 300
      records = [
        "bar",
        "baz.baz",
        "boop.example.net.",
      ]
    },
    {
      name = "foo"
      type = "DNAME"
      ttl  = 300
      records = [
        "bar",
        "baz.baz",
        "boop.example.net.",
      ]
    },
    {
      name = "foo"
      type = "MX"
      ttl  = 300
      records = [
        "1 bar",
        "1 baz.baz",
        "2 boop.example.net.",
      ]
    },
    {
      name = "foo"
      type = "SRV"
      ttl  = 300
      records = [
        "1 1 1 bar",
        "1 1 1 baz.baz",
        "2 2 2 boop.example.net.",
      ]
    },
    {
      name = "foo"
      type = "NS"
      ttl  = 300
      records = [
        "bar",
        "baz.baz",
        "boop.example.net.",
      ]
    },
    {
      name = "foo"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
  ]
}

data "testing_assertions" "result" {
  subject = "The normalized result"

  equal "matches" {
    statement = "is correct"

    got = module.tested.normalized
    want = toset([
      {
        name = "foo"
        type = "CNAME"
        ttl  = 300
        records = toset([
          "bar.example.com.",
          "baz.baz.example.com.",
          "boop.example.net.",
        ])
      },
      {
        name = "foo"
        type = "DNAME"
        ttl  = 300
        records = toset([
          "bar.example.com.",
          "baz.baz.example.com.",
          "boop.example.net.",
        ])
      },
      {
        name = "foo"
        type = "MX"
        ttl  = 300
        records = toset([
          "1 bar.example.com.",
          "1 baz.baz.example.com.",
          "2 boop.example.net.",
        ])
      },
      {
        name = "foo"
        type = "SRV"
        ttl  = 300
        records = toset([
          "1 1 1 bar.example.com.",
          "1 1 1 baz.baz.example.com.",
          "2 2 2 boop.example.net.",
        ])
      },
      {
        name = "foo"
        type = "NS"
        ttl  = 300
        records = toset([
          "bar.example.com.",
          "baz.baz.example.com.",
          "boop.example.net.",
        ])
      },
      {
        name = "foo"
        type = "A"
        ttl  = 300
        records = toset([
          "127.0.0.1",
        ])
      },
    ])
  }

  depends_on = [null_resource.shim]
}

resource "null_resource" "shim" {
  # this is here just to force testing_assertions to be read
  # during apply even though it doesn't depend on any resources.
  triggers = {
    every_time = uuid()
  }
}
