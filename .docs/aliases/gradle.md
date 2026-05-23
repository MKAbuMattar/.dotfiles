# gradle-aliases

## NAME

**gradle-aliases** — short prefixes for the Gradle wrapper and CLI.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "gradle" ...)
```

## DESCRIPTION

The module exits early via `(( ! $+commands[gradle] )) && return` when the
`gradle` binary is not on `$PATH`, so the aliases never pollute shells on
machines without Gradle. When loaded, it exposes two parallel families:

- **`gw*`** — invoke the project-local Gradle Wrapper (`./gradlew`).
- **`gradle-*`** — invoke the system-wide `gradle` binary.

Most everyday work uses the wrapper because it pins the build to the
declared Gradle version.

## ALIASES

### Wrapper — lifecycle

| Alias   | Expansion                               | Description             |
| ------- | --------------------------------------- | ----------------------- |
| `gw`    | `./gradlew`                             | Bare wrapper.           |
| `gwb`   | `./gradlew build`                       | Build.                  |
| `gwc`   | `./gradlew clean`                       | Clean.                  |
| `gwcb`  | `./gradlew clean build`                 | Clean then build.       |
| `gwt`   | `./gradlew test`                        | Test.                   |
| `gwbt`  | `./gradlew build test`                  | Build then test.        |
| `gwct`  | `./gradlew clean test`                  | Clean then test.        |
| `gwcbt` | `./gradlew clean build test`            | Clean, build, test.     |
| `gwr`   | `./gradlew run`                         | Run the application.    |
| `gwi`   | `./gradlew init`                        | Initialise a new build. |
| `gwp`   | `./gradlew publish`                     | Publish artifacts.      |
| `gwpub` | `./gradlew publish`                     | Same as `gwp`.          |
| `gwd`   | `./gradlew dependencies`                | Show dependency tree.   |
| `gwu`   | `./gradlew --refresh-dependencies`      | Force-refresh deps.     |
| `gwup`  | `./gradlew dependencies --update-locks` | Update dep locks.       |

### Wrapper — common tasks

| Alias       | Expansion            | Description            |
| ----------- | -------------------- | ---------------------- |
| `gwas`      | `./gradlew assemble` | Assemble artifacts.    |
| `gwch`      | `./gradlew check`    | Run checks.            |
| `gwjar`     | `./gradlew jar`      | Build the jar.         |
| `gwwar`     | `./gradlew war`      | Build the war.         |
| `gwboot`    | `./gradlew bootRun`  | Spring Boot run.       |
| `gwbootjar` | `./gradlew bootJar`  | Spring Boot fat jar.   |
| `gwinstall` | `./gradlew install`  | Install to local repo. |

### Wrapper — parallel and modes

| Alias     | Expansion                     | Description                   |
| --------- | ----------------------------- | ----------------------------- |
| `gwba`    | `./gradlew build --parallel`  | Parallel build.               |
| `gwta`    | `./gradlew test --parallel`   | Parallel tests.               |
| `gwca`    | `./gradlew clean --parallel`  | Parallel clean.               |
| `gwv`     | `./gradlew --console=verbose` | Verbose console.              |
| `gwdebug` | `./gradlew --debug`           | Debug logging.                |
| `gwinfo`  | `./gradlew --info`            | Info logging.                 |
| `gwo`     | `./gradlew --offline`         | Offline mode.                 |
| `gwcont`  | `./gradlew --continue`        | Don't abort on first failure. |
| `gwnd`    | `./gradlew --no-daemon`       | Disable daemon.               |

### Wrapper — daemon and info

| Alias        | Expansion              | Description              |
| ------------ | ---------------------- | ------------------------ |
| `gwstop`     | `./gradlew --stop`     | Stop the build daemon.   |
| `gwstatus`   | `./gradlew --status`   | Daemon status.           |
| `gwhelp`     | `./gradlew help`       | Help.                    |
| `gwtasks`    | `./gradlew tasks`      | List tasks.              |
| `gwprops`    | `./gradlew properties` | Show project properties. |
| `gwprojects` | `./gradlew projects`   | List sub-projects.       |

### System Gradle

| Alias                 | Expansion             | Description             |
| --------------------- | --------------------- | ----------------------- |
| `gradle-init`         | `gradle init`         | Scaffold a new project. |
| `gradle-build`        | `gradle build`        | Build.                  |
| `gradle-clean`        | `gradle clean`        | Clean.                  |
| `gradle-test`         | `gradle test`         | Test.                   |
| `gradle-run`          | `gradle run`          | Run.                    |
| `gradle-dependencies` | `gradle dependencies` | Dependency tree.        |
| `gradle-tasks`        | `gradle tasks`        | List tasks.             |
| `gradle-projects`     | `gradle projects`     | List sub-projects.      |

## REQUIREMENTS

- `gradle` on `$PATH` at shell-startup time (probed with
  `(( ! $+commands[gradle] )) && return`).
- A project-local `./gradlew` wrapper for the `gw*` aliases.

## EXAMPLES

```bash
gwcb               # ./gradlew clean build
gwba -x test       # parallel build, skip tests
gwboot             # Spring Boot dev loop
gwstop             # kill the daemon
gradle-init        # scaffold via the system gradle
```

## SEE ALSO

- [.docs/README.md](../README.md)
