variable "enabled" {
  type    = bool
  default = true
}
variable "module_depends_on" {
  default     = [""]
  type        = list(any)
  description = "a depends_on variable to be used as a flag between modules untl terraform supports depends_on for modules"
}
locals {
  count              = var.enabled == true ? 1 : 0
  name               = "wordpress"
  wordpressUsername  = "jagbonkhese"
  wordpressPassword  = ""
  wordpressEmail     = ""
  wordpressFirstName = "joseph"
  wordpressLastName  = "agbonkhese"
  wordpressBlogName  = "joekhese.com"
}


resource "helm_release" "wordpress" {
  count            = var.enabled == true ? 1 : 0
  name             = local.name
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "wordpress"
  create_namespace = true
  namespace        = "wordpress"
  cleanup_on_fail  = true

  values = [
    templatefile("${path.module}/values.yaml", {
      wordpressUsername  = local.wordpressUsername,
      wordpressPassword  = local.wordpressPassword,
      wordpressEmail     = local.wordpressEmail,
      wordpressFirstName = local.wordpressFirstName,
      wordpressLastName  = local.wordpressLastName,
      wordpressBlogName  = local.wordpressBlogName,
    })
  ]
}

resource "null_resource" "module_depends_on" {
  count = var.enabled == true ? 1 : 0

  triggers = {
    value = length(var.module_depends_on)
  }
}
