
# We access the default VPC (data source)
data "aws_vpc" "default" {
   default = true
}

# ...and use the subnets that come with the default VPC
data "aws_subnet_ids" "default" {
   # By referencing the block above we can determine the ID of the default VPCs
   vpc_id = data.aws_vpc.default.id
   filter {
       name = "availability-zone"
       values = ["us-east-1a","us-east-1b","us-east-1c"]
   }
}