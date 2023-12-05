variable "users" {
  type    = list(string)
  default = ["demo-user", "admin1", "john"]
}

# Creating IAM users
resource "aws_iam_user" "test" {
  for_each = toset(var.users) # Converts a list to a set
  name     = each.value

  tags = {
    Name = "test-$(var.users.aws_iam_user)"
  }
}

output "usersss" {
  value = aws_iam_user.test[*].name # Use each.value.name to get the name attribute
}

