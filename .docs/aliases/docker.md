# docker-aliases

## NAME

**docker-aliases** — short prefixes for the Docker CLI (containers, images, networks, volumes).

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "docker" ...)
```

## DESCRIPTION

Two- to seven-character shortcuts covering the day-to-day Docker workflow:
running and inspecting containers, building and pushing images, managing
networks and volumes, and tailing logs. All aliases load unconditionally —
no runtime probe — so the `docker` binary must be on `$PATH`.

One alias name is **quoted** because of the `!` character: `'drm!'` is the
literal alias name. Invoke it as `drm!` at the shell prompt; the surrounding
quotes are only required at definition time.

## ALIASES

### Build / image

| Alias   | Expansion               | Description                     |
| ------- | ----------------------- | ------------------------------- |
| `dbl`   | `docker build`          | Build from a Dockerfile in cwd. |
| `dib`   | `docker image build`    | Same, explicit subcommand.      |
| `dii`   | `docker image inspect`  | Inspect an image.               |
| `dils`  | `docker image ls`       | List local images.              |
| `dipu`  | `docker image push`     | Push to a registry.             |
| `dipru` | `docker image prune -a` | Prune all unused images.        |
| `dirm`  | `docker image rm`       | Remove image(s).                |
| `dit`   | `docker image tag`      | Tag an image.                   |
| `dpu`   | `docker pull`           | Pull an image.                  |

### Container lifecycle

| Alias   | Expansion                     | Description                            |
| ------- | ----------------------------- | -------------------------------------- |
| `dr`    | `docker container run`        | Run a one-shot container.              |
| `drit`  | `docker container run -it`    | Run interactively with TTY.            |
| `dst`   | `docker container start`      | Start a stopped container.             |
| `drs`   | `docker container restart`    | Restart.                               |
| `dstp`  | `docker container stop`       | Stop.                                  |
| `dsta`  | `docker stop $(docker ps -q)` | Stop every running container.          |
| `drm`   | `docker container rm`         | Remove.                                |
| `drm!`  | `docker container rm -f`      | Force-remove (still running).          |
| `dxc`   | `docker container exec`       | Exec a command in a running container. |
| `dxcit` | `docker container exec -it`   | Exec with interactive TTY.             |

### Container introspection

| Alias   | Expansion                  | Description                  |
| ------- | -------------------------- | ---------------------------- |
| `dps`   | `docker ps`                | List running containers.     |
| `dpsa`  | `docker ps -a`             | Include stopped containers.  |
| `dcin`  | `docker container inspect` | Inspect a container.         |
| `dcls`  | `docker container ls`      | List running (verbose form). |
| `dclsa` | `docker container ls -a`   | List all.                    |
| `dlo`   | `docker container logs`    | Show container logs.         |
| `dpo`   | `docker container port`    | Show port mappings.          |
| `dsts`  | `docker stats`             | Live resource stats.         |
| `dtop`  | `docker top`               | Show container processes.    |

### Networks

| Alias   | Expansion                   | Description                    |
| ------- | --------------------------- | ------------------------------ |
| `dnls`  | `docker network ls`         | List networks.                 |
| `dnc`   | `docker network create`     | Create a network.              |
| `dni`   | `docker network inspect`    | Inspect a network.             |
| `dnrm`  | `docker network rm`         | Remove a network.              |
| `dncn`  | `docker network connect`    | Attach container to network.   |
| `dndcn` | `docker network disconnect` | Detach container from network. |

### Volumes

| Alias     | Expansion               | Description           |
| --------- | ----------------------- | --------------------- |
| `dvls`    | `docker volume ls`      | List volumes.         |
| `dvi`     | `docker volume inspect` | Inspect a volume.     |
| `dvprune` | `docker volume prune`   | Prune unused volumes. |

## REQUIREMENTS

- `docker` CLI (Docker Engine or Docker Desktop).

## EXAMPLES

```bash
dbl -t app:dev .
drit --rm -v "$PWD":/src app:dev bash
dps                              # what's running?
dlo -f my-app                    # tail logs
dsta                             # panic-stop everything
drm! $(dpsa -q)                  # force-remove every container
```

## SEE ALSO

- [.docs/plugins/zsh/docker.md](../plugins/zsh/docker.md)
- [.docs/README.md](../README.md)
