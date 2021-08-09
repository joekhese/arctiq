locals {
  //enabled = true
  count = var.enabled == true ? 1 : 0
  name = "consul"
  replicas = 1
  datacenter = "arctiq"

}

variable "enabled" {
  type    = bool
  default = true
}

variable "module_depends_on" {
  default     = [""]
  type        = list(any)
  description = "a depends_on variable to be used as a flag between modules untl terraform supports depends_on for modules"
}


resource "helm_release" "consul" {
  count = var.enabled == true ? 1 : 0
  name  = local.name
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "consul"
  create_namespace = true
  namespace        = "consul"

  values = [
    templatefile("${path.module}/values.yaml", {
      datacenter = local.datacenter,
      name = local.name
    })
  ]
}

resource "null_resource" "module_depends_on" {
  count = var.enabled == true ? 1 : 0

  triggers = {
    value = length(var.module_depends_on)
  }
}