# mvn-plugin

## NAME

**mvn-plugin** — hand-written `compctl` completion for Apache Maven
that discovers POM profiles and submodules on the fly.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "mvn" ...)
```

## DESCRIPTION

Unlike most plugins in this collection, the Maven plugin does not call
out to the tool for a generated completion script. It defines a shell
function `listMavenCompletions` and wires it up via the classic
`compctl -K` mechanism for `mvn`, `mvnw`, `mvn-color`, and
`mvn-or-mvnw`.

Each time completion is requested, the function:

1. Builds a list of POM files starting with `~/.m2/settings.xml` and
   the current directory's `pom.xml`, then walks the `<parent>` /
   `<relativePath>` chain up to the root POM.
2. Extracts every `<profile><id>...</id>` value from those files and
   turns them into `-P<id>` candidates.
3. Globs every nested `pom.xml(-.N:h)` to suggest module directories,
   filtering out `target/classes/META-INF/` artifacts.
4. Emits a large static list of lifecycle phases, common plugins
   (deploy, surefire, javadoc, jxr, pmd, ant, archetype, assembly,
   dependency, enforcer, gpg, release, scm, war, ear, android, sonar,
   liquibase, flyway, gwt, asciidoctor, liberty, vaadin, quarkus,
   spring-boot, etc.) and well-known options (`-am`, `-DskipTests`,
   `-T`, `-X`, …).

The result is project-aware completion without requiring any
external completion generator.

## EFFECTS

- Returns immediately if `mvn` is not on PATH.
- Defines the global function `listMavenCompletions`.
- Registers it via `compctl -K listMavenCompletions` for `mvn`,
  `mvnw`, `mvn-color`, and `mvn-or-mvnw`.
- Reads `~/.m2/settings.xml` and any `pom.xml` reachable from the
  current directory upward each time completion is requested.

## FUNCTIONS

- `listMavenCompletions` — populates `$reply` with lifecycle phases,
  common plugin goals, parsed profiles (as `-P<id>`), and submodule
  directories. Invoked automatically by `compctl`.

## ENVIRONMENT

None.

## FILES

- `~/.m2/settings.xml` — read for profile definitions.
- `./pom.xml` and ancestor `pom.xml` files reached via `<parent>` /
  `<relativePath>` — read for profile definitions and used to discover
  submodules via `**/pom.xml`.
- `.plugins/.zsh/mvn/mvn.plugin.zsh` — the plugin source.

## REQUIREMENTS

- `mvn` on PATH.
- POSIX `grep` and `sed` (used to parse POM XML lightly).

## KEY BINDINGS

None.

## SEE ALSO

- [.docs/aliases/mvn](../../aliases/mvn.md)
- [.docs/utils/mvn](../../utils/mvn.md)
- [.docs/README.md](../../README.md)
