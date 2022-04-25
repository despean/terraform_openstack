variable "domain" {
  default = "cidgoh.ca"
  type = string
}

variable "deploymentfile" {
  default = "covidmvp.sh"
  type = string
}

variable "instance_name" {
  default = "COVID MVP Test deploy"
  type = string
}

variable "network" {
  default = "Public-Network"
  type = string
}