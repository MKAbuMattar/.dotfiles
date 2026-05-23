# mvn-aliases

## NAME

**mvn-aliases** — short aliases for Apache Maven build lifecycle commands, with automatic Maven Wrapper (`mvnw`) preference.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "mvn" ...)
```

## DESCRIPTION

Provides short aliases for the most common Maven goals: clean, compile, package, install, verify, deploy, dependency tree, and framework-specific runners (Spring Boot, Quarkus, Jetty, Tomcat). The module is gated by `(( ! $+commands[mvn] )) && return`, so it loads only when `mvn` is on `$PATH`.

**Important:** the module re-aliases `mvn` itself to `mvn-or-mvnw`, a helper that prefers the project-local Maven Wrapper (`./mvnw`) when one is present, falling back to the system `mvn` otherwise. All downstream aliases (`mvnci`, `mvnp`, etc.) therefore also pick up the wrapper transparently.

It also defines `mvn!`, which runs Maven against the `pom.xml` at the root of the current git repository (or the current directory if not inside a git repo).

## ALIASES

### Core / Wrapper

| Alias  | Expansion                                         | Description                                |
| ------ | ------------------------------------------------- | ------------------------------------------ |
| `mvn`  | `mvn-or-mvnw`                                     | Use `./mvnw` if present, else system `mvn` |
| `mvn!` | `mvn -f $(git rev-parse --show-toplevel)/pom.xml` | Run Maven against the repo-root pom        |

### Lifecycle

| Alias    | Expansion                | Description               |
| -------- | ------------------------ | ------------------------- |
| `mvnc`   | `mvn clean`              | Clean                     |
| `mvncom` | `mvn compile`            | Compile                   |
| `mvnt`   | `mvn test`               | Run tests                 |
| `mvnp`   | `mvn package`            | Package                   |
| `mvnv`   | `mvn verify`             | Verify                    |
| `mvnvst` | `mvn verify -DskipTests` | Verify without tests      |
| `mvndp`  | `mvn deploy`             | Deploy artifacts          |
| `mvns`   | `mvn site`               | Generate the project site |

### Clean Combinations

| Alias      | Expansion                                 | Description                         |
| ---------- | ----------------------------------------- | ----------------------------------- |
| `mvnci`    | `mvn clean install`                       | Clean + install                     |
| `mvncist`  | `mvn clean install -DskipTests`           | Clean install without tests         |
| `mvncisto` | `mvn clean install -DskipTests --offline` | Clean install, no tests, offline    |
| `mvncini`  | `mvn clean initialize`                    | Clean + initialize                  |
| `mvncp`    | `mvn clean package`                       | Clean + package                     |
| `mvnct`    | `mvn clean test`                          | Clean + test                        |
| `mvncv`    | `mvn clean verify`                        | Clean + verify                      |
| `mvncvst`  | `mvn clean verify -DskipTests`            | Clean + verify, no tests            |
| `mvncd`    | `mvn clean deploy`                        | Clean + deploy                      |
| `mvnce`    | `mvn clean eclipse:clean eclipse:eclipse` | Clean + regenerate Eclipse metadata |
| `mvncie`   | `mvn clean install eclipse:eclipse`       | Clean install + Eclipse metadata    |

### Dependencies & Sources

| Alias         | Expansion                                     | Description             |
| ------------- | --------------------------------------------- | ----------------------- |
| `mvndt`       | `mvn dependency:tree`                         | Show dependency tree    |
| `mvnsrc`      | `mvn dependency:sources`                      | Download source jars    |
| `mvndocs`     | `mvn dependency:resolve -Dclassifier=javadoc` | Download javadoc jars   |
| `mvn-updates` | `mvn versions:display-dependency-updates`     | List dependency updates |

### Frameworks / Runners

| Alias      | Expansion             | Description                  |
| ---------- | --------------------- | ---------------------------- |
| `mvnboot`  | `mvn spring-boot:run` | Run a Spring Boot app        |
| `mvnqdev`  | `mvn quarkus:dev`     | Run Quarkus dev mode         |
| `mvnjetty` | `mvn jetty:run`       | Run an embedded Jetty server |
| `mvntc`    | `mvn tomcat:run`      | Run an embedded Tomcat       |
| `mvntc7`   | `mvn tomcat7:run`     | Run an embedded Tomcat 7     |

### Misc

| Alias    | Expansion                | Description                          |
| -------- | ------------------------ | ------------------------------------ |
| `mvnag`  | `mvn archetype:generate` | Generate a project from an archetype |
| `mvne`   | `mvn eclipse:eclipse`    | Generate Eclipse metadata            |
| `mvnfmt` | `mvn fmt:format`         | Run the `fmt-maven-plugin` formatter |

## REQUIREMENTS

- `mvn` installed and on `$PATH`.
- A `mvn-or-mvnw` shim or function on `$PATH` (provided by the companion plugin) for the wrapper-preferring behaviour to work.
- For `mvn!`: `git` and a repository that contains a top-level `pom.xml`.

## EXAMPLES

```bash
# Quick clean install without running tests
mvncist

# Display the dependency tree of the current module
mvndt

# Run Spring Boot from anywhere inside the repo
mvn!  spring-boot:run

# Generate a new project interactively
mvnag
```

## SEE ALSO

- [.docs/plugins/zsh/mvn](../plugins/zsh/mvn.md)
- [.docs/README.md](../README.md)
