variable "nic_id" {
  type = string
#   type = list(string)
}

variable "asgs" {
  type = map(object(
    {
      asg_name   = string
      asg_rgname = string
  }))
}

#asgs example
# asgs = {
#     "1" = {
#         asg_name        = "asg1",
#         asg_rgname      = "rgname1"
#     },
#     "2" = {
#         asg_name        = "asg2",
#         asg_rgname      = "rgname2"
#     },
# }

variable "subscription_id" {
  type = string
}
