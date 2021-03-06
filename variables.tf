variable "access_key" { 
  description = "AWS access key"
}

variable "secret_key" { 
  description = "AWS secret access key"
}

variable "region"     { 
  description = "AWS region to host your network"
  default     = "us-west-2" 
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.198.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default     = "10.198.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  default     = "10.198.1.0/24"
}

variable "private_subnet_cidr_daas" {
  description = "CIDR for private subnet"
  default     = "10.198.16.0/24"
}

/*
variable "vpc_id"            {}
variable "private_gw_id"     {}
variable "customer_gw_ip"    {}*/
variable "vpc_name"          { default = "angoss-vpc"}
variable "customer_gw_name"  { default = "rovi-tulsa"}
variable "customer_gw_asn"   { default = "60000"  }
variable "destination_cidrs" { default = "10.0.0.0/8,172.16.0.0/12,192.168.0.0/24,192.168.16.0/24,144.198.191.20/32"}

variable "ipsec_peering_point" {
  description = "Rovi IPSec peering point"
  default = "144.198.191.20"
}

/* Ubuntu 14.04 amis by region */
variable "amis" {
  description = "Base AMI to launch the instances with"
  default = {
    us-west-1 = "ami-049d8641" 
    us-west-2 = "ami-9abea4fb" 
    us-east-1 = "ami-a6b8e7ce"
  }
}

/* Windows Server 2008 R2 amis by region */
variable "amis-win" {
  description = "Base AMI to launch the instances with"
  default = {
    us-west-2 = "ami-b3d92ed3" 
  }
}

/* Windows Server 2008 R2 with MS SQL amis by region */
variable "amis-win-sql" {
  description = "Base AMI to launch the instances with"
  default = {
    us-west-2 = "ami-1030c770" 
  }
}

/* */
variable "rdp_access_cidrs" {
  default = {
    san-carlos-office = "144.198.19.10/32"
    tulsa-dc          = "144.198.191.17/32"
    burbank-office    = "144.198.182.10/32"
    waine-office      = "144.198.30.2/32"
    /*burbank-office2   = "144.198.191.17/32" duplicate value with tulsa-dc, causing terraform error" */
    bangalore-office  = "182.74.246.98/32"
    gevgev-home       = "97.94.186.32/32"
  }
}

variable "ssh_access_cidrs" {
  default = {
    san-carlos-office = "144.198.19.10/32"
    tulsa-dc          = "144.198.191.17/32"
    burbank-office    = "144.198.182.10/32"
    /*burbank-office2   = "144.198.191.17/32" duplicate value with tulsa-dc, causing terraform error" */
    bangalore-office  = "182.74.246.98/32"
    gevgev-home       = "97.94.186.32/32"
  }
}

variable "rovi_access_cidrs" {
  default = {
    san-carlos-office = "144.198.19.10/32"
    tulsa-dc          = "144.198.191.17/32"
    burbank-office    = "144.198.182.10/32"
    /*burbank-office2   = "144.198.191.17/32" duplicate value with tulsa-dc, causing terraform error" */
    bangalore-office  = "182.74.246.98/32"
    gevgev-home       = "97.94.186.32/32"
  }
}

variable "rovi_numerx_access_cidr" {
  default = {
    rovi-internal-01 = "10.0.0.0/8"
    rovi-internal-02 = "172.16.0.0/12"
    aws-sub-01 = "192.168.0.0/24"
    aws-sub-02 = "192.168.16.0/24"
  }

}