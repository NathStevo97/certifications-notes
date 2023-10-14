# 2.16 - Dynamic Blocks

- Often there are repeatable nested blocks of resource code that need to be defined.
- If not managed carefully, this could lead to long stretches of code that are difficult to manage. Commonly, this occurs with resources that have multiple entries e.g.:
  - Security Groups
  - Ingress Rules
  - Egress Rules

- To work with this, one can use a dynamic block, indicated by the usage of `dynamic` prior to the resource identifier.
- Dynamic blocks allow you to iteratively add content defined in a separate variable list or map.

- Ingress Property Example:

```go

resource "aws_security_group" "dynamicsg" {
    name = "dynamic-sg"
    description = "Ingress for Vault"

    dynamic "ingress" {
        for_each = var.sg_ports
        iterator = port
        content {
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    dynamic "egress" {
        for_each = var.sg_ports
        content {
            from_port = egress.value
            to_port = egress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}

```

- This dynamic block will iteratively fill out the contents of the ingress and egress blocks with the content defined in a separate variable as a list. The egress block is filled out in a similar manner.

- Iterators are optional arguments which set the name of a temporary variable that represents the current element of a more complex value. It's commonly seen in conjunction with the `for_each` operator i.e. `for_each = var.sg_ports` - where `sg_ports` is a list to be iterated over.

- If omitted, the name of the variable defaults to the dynamic block's label (similar to the egress example above).
