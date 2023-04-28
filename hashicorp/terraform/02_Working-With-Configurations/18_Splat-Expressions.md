# 2.18 - Splat Expressions

- An expression that produces a list of all the attributes, denoted by *.
- Essentially denotes "anything" or "all".
- Example:

```go
provider "aws" {
    region = "eu-west-2"
}

resource "aws_iam_user" "lb" {
    name  "iamuser.${count.index}"
    count = 3
    path = "/system/"
}

output "arns" {
    value = aws_iam_user.lb[*].arn
}
```

- The above aims to create 3 IAM users in AWS.
- The value `aws_iam_user.lb[*].arn` will look for each 3 arn assoicated with the IAM user.
- The resultant output will therefore be:

```go
arns = [
"arn:aws:iam::746085785702:user/system/iamuser.0",
"arn:aws:iam::746085785702:user/system/iamuser.1",
"arn:aws:iam::746085785702:user/system/iamuser.2"
]
```

- This could also be applied to any other listable properties.
- Officially: *A splat expression provides a more concise way to express a common operation that could otherwise be performed by a `for` operation*
