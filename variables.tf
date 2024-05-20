variable "region" {
  type    = string
  default = ""
}

variable "identifier" {
  type    = string
  default = ""
}

variable "project" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = ""
}

variable "tags" {
  default = {}
}

variable "server" {
  type = any
}

variable "users" {
  type = any
}
