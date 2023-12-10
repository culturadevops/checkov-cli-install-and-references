resource "aws_iam_policy" "example" {
  # ... other configuration ...
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
}
POLICY
}

resource "aws_iam_policy" "example" {
  # ... other configuration ...

  policy = "{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", \"Action\": \"*\", \"Resource\": \"*\"}}"
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "example" {
  # ... other configuration ...

  policy = "${data.aws_iam_policy_document.example.json}"
}