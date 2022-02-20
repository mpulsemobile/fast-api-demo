# Generated with .waypoint-tmpl.sh

project = "fast-api"

runner {
  enabled = true
}

app "web" {
  config {
    env = {
      ENV = var.ENV
    }
  }

  build {
    use "docker" {
      dockerfile = "docker/Dockerfile"
      entrypoint = "/app/docker"
    }

    registry {
      use "aws-ecr" {
        tag        = var.image_tag
        repository = "fast-api"
      }
    }
  }

  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/.jobspec.nomad", {
        kv_path      = var.ENV,
        image        = "${artifact.image}:${artifact.tag}",
        datacenter   = var.nomad_datacenter,
        job_name     = var.nomad_jobname,
        url_hostname = "fast-api.${var.dns_domain}",
        cpu          = var.cpu,
        memory       = var.memory_soft_limit,
        memory_max   = var.memory_hard_limit
      })
    }
  }
}

# Variables
variable "image_tag" {
  type    = string
  default = "latest"
}

variable "ENV" {
  type    = string
  default = null
}

variable "nomad_datacenter" {
  type        = string
  description = "The Nomad datacenter we are deploying to. Set the ENV WP_VAR_nomad_datacenter."
}

variable "nomad_jobname" {
  type        = string
  description = "The name of the job in Nomad."
  default     = "report-builder"
}

variable "ecr_repo" {
  type        = string
  description = "A URL to the ECR repository"
}

variable "dns_domain" {
  type        = string
  description = "The DNS domain hosts are on."
}

variable "cpu" {
  type    = number
  default = 300
}

variable "memory_soft_limit" {
  type    = number
  default = 350
}

variable "memory_hard_limit" {
  type    = number
  default = 600
}