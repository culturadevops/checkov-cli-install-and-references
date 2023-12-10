resource "aws_iam_policy" "example" {
  # ... other configuration ...

  policy = "${file("policy.json")}"
}



data "template_file" "example1" {
  template = "${file("policy.json.tpl")}"

  vars = {
    resource = "${aws_vpc.example.arn}"
  }
}



resource "aws_iam_policy" "example1" {
  # ... other configuration ...

  policy = "${data.template_file.example.rendered}"
}