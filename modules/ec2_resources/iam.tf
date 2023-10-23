# trust policy document to allow EC2 resources to assume this role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# attach trust policy document to IAM role
resource "aws_iam_role" "role" {
  name               = "${var.proj_name}-ecsInstanceRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


locals {
  instance_profile_name = "${var.proj_name}-instance-profile-for-ecsInstanceRole"
}

# an instance profile is required for EC2
# EC2 instance runs under the EC2 instance profile
# it then “assumes” the IAM role, which ultimately gives it any real power
# The only permissions an EC2 instance profile has is the power to assume a role
resource "aws_iam_instance_profile" "instance_profile" {
  name = local.instance_profile_name
  role = aws_iam_role.role.name # implicit dependency on aws_iam_role.role
}

data "aws_iam_policy" "ec2_for_ecs_policy" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

# Use aws_iam_policy_attachment to map a single policy to multiple role
resource "aws_iam_policy_attachment" "attach_ec2_for_ecs_policy" {
  name       = "${var.proj_name}-policy-attach-EC2-for-ECS"
  policy_arn = data.aws_iam_policy.ec2_for_ecs_policy.arn
  roles      = [aws_iam_role.role.name]
}

# # Use aws_iam_role_policy_attachment to map an iam policy to a single role
# resource "aws_iam_role_policy_attachment" "attach_ec2_for_ecs_policy" {
#   policy_arn = data.aws_iam_policy.ec2_for_ecs_policy.arn
#   role       = aws_iam_role.role.name
# }