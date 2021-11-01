variable "prefix" {}
variable "location" {}
variable "vnetcidr" {}
variable "websubnetcidr" {}
variable "appsubnetcidr" {}
variable "webhostname"{}
variable "apphostname"{}
variable "replication"{}
variable "secretpass"{ 
    sensitive   = true 
}
variable "hostuser"{
    sensitive   = true
}