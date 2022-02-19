job "${job_name}" {
  datacenters = ["${datacenter}"]

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

          }
        }
      }

    task "app" {
      driver = "docker"

      resources {
        cpu    = ${cpu}
        memory = ${memory}
      }

      config {
        image             = "${image}"
        memory_hard_limit = ${memory_max}
      }

      template {
        data = <<-EOF
        PG_NAME = "{{with secret "kv/data/report-builder/${kv_path}"}}{{.Data.data.PG_DB}}{{end}}"
        PG_USERNAME = "{{with secret "kv/data/report-builder/${kv_path}"}}{{.Data.data.PG_USERNAME}}{{end}}"
        PG_PASSWORD = "{{with secret "kv/data/report-builder/${kv_path}"}}{{.Data.data.PG_PASSWORD}}{{end}}"
        LOG_LEVEL = "{{with secret "kv/data/report-builder/${kv_path}"}}{{.Data.data.LOG_LEVEL}}{{end}}"
        EOF
        destination = ".env"
        env = true
      }

      env {
        %{ for k, v in entrypoint.env ~}
        ${k} = "${v}"
        %{ endfor ~}

        PG_HOST   = "$${NOMAD_UPSTREAM_IP_mpulse-postgresql-shared}"
      }
    }
  }
}