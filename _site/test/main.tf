variable "myvar" {
  type = string
  default = "Hello terraform"
}
# > var.myvar
# "Hello terraform"

# > "${var.myvar}"
# "Hello terraform"

variable "mymap" {
  type = map(string)
  default = {
    mykey = "my value"
  }
}

# > var.mymap["mykey"]
# "my value"

# > "${var.mymap["mykey"]}"
# "my value"

variable "mylist" {
  type = list
  default = [1, 2, 3]
}
# > var.mylist
# tolist([
#   1,
#   2,
#   3,
# ])

# > var.mylist[0]
# 1

# > element(var.mylist, 0)
# 1

# > slice(var.mylist, 0, 2)
# tolist([
#   1,
#   2,
# ])