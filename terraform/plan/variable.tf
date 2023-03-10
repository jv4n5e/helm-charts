variable "private_network_config" {
  type = map(object({
      cidr_block               = string
      az                       = string
      associated_public_subnet = string
      eks                      = bool
  }))

  default = {
    "private-eks-1" = {
        cidr_block               = "10.0.0.0/23"
        az                       = "af-south-1a"
        associated_public_subnet = "public-eks-1"
        eks                      = true
    },
    "private-eks-2" = {
        cidr_block               = "10.0.2.0/23"
        az                       = "af-south-1b"
        associated_public_subnet = "public-eks-2"
        eks                      = true
    }/*,
    "private-rds-1" = {
        cidr_block               = "10.0.4.0/24"
        az                       = "af-south-1a"
        associated_public_subnet = ""
        eks                      = false
    },
    "private-rds-2" = {
        cidr_block               = "10.0.5.0/24"
        az                       = "af-south-1b"
        associated_public_subnet = ""
        eks                      = false
    }*/
  }
}

locals {
    private_nested_config = flatten([
        for name, config in var.private_network_config : [
            {
                name                     = name
                cidr_block               = config.cidr_block
                az                       = config.az
                associated_public_subnet = config.associated_public_subnet
                eks                      = config.eks
            }
        ]
    ])
}

variable "public_network_config" {
  type = map(object({
      cidr_block              = string
      az                      = string
      nat_gw                  = bool
      eks                     = bool
  }))

  default = {
    "public-eks-1" = {
        cidr_block = "10.0.6.0/23"
        az = "af-south-1a"
        nat_gw = true
        eks = true
    },
    "public-eks-2" = {
        cidr_block = "10.0.8.0/23"
        az = "af-south-1b"
        nat_gw = true
        eks = true
    }/*,
    "public-rds-1" = {
        cidr_block = "10.0.10.0/24"
        az = "af-south-1a"
        nat_gw = false
        eks = false
    },
    "public-rds-2" = {
        cidr_block = "10.0.11.0/24"
        az = "eu-west-1b"
        nat_gw = false
        eks = false
    }*/
  }
}

locals {
    public_nested_config = flatten([
        for name, config in var.public_network_config : [
            {
                name                    = name
                cidr_block              = config.cidr_block
                az                      = config.az
                nat_gw                  = config.nat_gw
                eks                     = config.eks
            }
        ]
    ])
}

variable "region" {
  type    = string
  default = "af-south-1"
}

variable "az" {
  type    = list(string)
  default = ["af-south-1a", "af-south-1b"]
}

variable "env" {
  type = string
  default = "scalegrid-demo"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "internal_ip_range" {
    type = string
    default = "0.0.0.0/0"
}

variable "eks_cluster_name" {
  type = string
  default = "eks-cluster-scalegrid-demo"
}