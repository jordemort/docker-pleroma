# pleroma

This is a Docker image for running [Pleroma](https://pleroma.social), based on the [official installation instructions](https://docs-develop.pleroma.social/backend/installation/otp_en/) and `ubuntu:20.04`. Build it yourself, or get it from [Docker Hub](https://hub.docker.com/r/jordemort/pleroma).

## Configuration

The container expects to find a Pleroma configuration file at `/etc/pleroma/config.exs`. If the configuration does not exist, the container will call `pleroma_ctl instance gen` for you. The parameters passed to `instance gen` can be influenced by a number of environment variables.

The three environment variables you MUST supply are:

- `DOMAIN`
- `ADMIN_EMAIL`
- `POSTGRES_PASSWORD`

The container will try to infer reasonable defaults for the rest of the variables, if not set. Note that some of these defaults may be different from Pleroma's own default settings:

| Argument | Evironment variable | Default value |
| -------- | ------------------- | ------------- |
| `--domain` | `DOMAIN` | _none_ |
| `--instance-name` | `INSTANCE_NAME` | same as `DOMAIN` |
|  `--admin-email` | `ADMIN_EMAIL` | _none_ |
| `--notify-email` | `NOTIFY_EMAIL` | same as `ADMIN_EMAIL` |
| `--dbhost` | `POSTGRES_HOST` | postgres  |
| `--dbname` | `POSTGRES_DB` | pleroma  |
| `--dbuser` | `POSTGRES_USER` | pleroma  |
| `--dbpass` | `POSTGRES_PASSWORD` | _none_ |
| `--rum` | `USE_RUM` | n |
| `--indexable` | `INDEXABLE` | y  |
| `--db-configurable` | `DB_CONFIGURABLE` | y  |
| `--uploads-dir` | `UPLOADS_DIR` | /var/lib/pleroma/uploads  |
| `--static-dir` | `STATIC_DIR` | /var/lib/pleroma/static  |
| `--listen-ip` | `LISTEN_IP` | 0.0.0.0  |
| `--listen-port` | `LISTEN_PORT` | 4000 |
| `--strip-uploads` | `STRIP_UPLOADS` | y |
| `--anonymize-uploads` | `ANONYMIZE_UPLOADS` | y |
| `--dedupe-uploads` | `DEDUPE_UPLOADS` | y |

See the [documentation for `instance gen`](https://docs-develop.pleroma.social/backend/administration/CLI_tasks/instance/) for more information.

If you want to use RUM indexes, you need a [PostgreSQL container that supports them](https://github.com/jordemort/docker-postgres-rum/).

## Persistence

If you want your instance data to persist properly, you need to mount volumes on the following directories:

- `/etc/pleroma`
- `/var/lib/pleroma/static`
- `/var/lib/pleroma/uploads`

Even if you aren't supplying a configuration and letting the container generate it for you, it is still important to persist the generated configuration in `/etc/pleroma` - it contains generated secrets, and things may get weird or broken if those change every time you restart your container.

## Example

The git repository for this container includes [an example of how to use it with `docker-compose`](https://github.com/jordemort/docker-pleroma/tree/main/example)

## Prior art & inspiration

- https://www.github.com/goodtiding5/docker-pleroma - based on Alpine, if you're into that sort of thing :)
