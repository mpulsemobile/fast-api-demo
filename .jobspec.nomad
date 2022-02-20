job "${job_name}" {
  datacenters = ["${datacenter}"]

  # TODO: We'll want to figure out a strategy with updates at some point.
  #   https://www.nomadproject.io/docs/job-specification/update
  #update { }

  group "app" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        to = 3000
      }
    }

    vault {
      policies  = ["kv_user"]
    }

    # This is the service that gets registered in Consul (the service mesh)
    service {
      name = "${job_name}"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.${job_name}.rule=Host(`${url_hostname}`)",
        "traefik.consulcatalog.connect=true",
      ]

      connect {
        sidecar_service {
          proxy {
            local_service_port = 3000

            # The DB upstreams need to be defined in the Terminating Gateway in Consul
            upstreams {
              destination_name = "mpulse-postgresql-shared"
              local_bind_port  = 5432
            }

            upstreams {
              destination_name = "mpulse-redshift"
              local_bind_port  = 5439
            }
          }
        }
      }

      # TODO: This ideally should be a bonafide health check endpoint
      #   The HTTP health check currently won't work because of ALLOWED_HOSTS. I think [this](https://github.com/mozmeao/django-allow-cidr)
      #   would be a good solution, but it does not seem to work with Py2.
      #check {
      #  type     = "http"
      #  path     = "/login"
      #  interval = "10s"
      #  timeout  = "10s"
      #}
    }

    task "app" {
      driver = "docker"

      resources {
        cpu    = ${cpu}
        memory = ${memory}
      }

      config {
        image             = "${image}"
        entrypoint = "docker/entrypoint.sh"
        memory_hard_limit = ${memory_max}
      }

      template {
        data = <<-EOF
        PG_NAME = "{{with secret "kv/data/report-builder/${kv_path}"}}{{.Data.data.PG_DB}}{{end}}"
        EOF
        destination = ".env"
        env = true
      }

      env {
        %{ for k, v in entrypoint.env ~}
        ${k} = "${v}"
        %{ endfor ~}

        PG_HOST   = "$${NOMAD_UPSTREAM_IP_mpulse-postgresql-shared}"
        LAKE_HOST = "$${NOMAD_UPSTREAM_IP_mpulse-redshift}"

        // if we want the URL service to function.
        // https://www.waypointproject.io/docs/url
        # PORT = "$${NOMAD_PORT_http}"
      }
    }
  }
}