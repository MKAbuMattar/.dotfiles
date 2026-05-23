# dotnet-aliases

## NAME

**dotnet-aliases** — short prefixes for the .NET CLI.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "dotnet" ...)
```

## DESCRIPTION

Two- and three-letter shortcuts for the day-to-day `dotnet` subcommands —
project scaffolding, building, running, testing, watching, and managing
solutions and NuGet packages. Aliases load unconditionally; the `dotnet`
runtime must be on `$PATH`.

> Note: some of these names (`dr`, `db`, `dp`, `da`) collide with the
> [docker](docker.md) module. Pick at most one of `dotnet` / `docker` in
> your `ALIASES=( … )` array, or be prepared for the later one to win.

## ALIASES

### Project lifecycle

| Alias  | Expansion        | Description                           |
| ------ | ---------------- | ------------------------------------- |
| `dn`   | `dotnet new`     | Create a new project from a template. |
| `db`   | `dotnet build`   | Build the current project / solution. |
| `dres` | `dotnet restore` | Restore NuGet packages.               |
| `dr`   | `dotnet run`     | Run the current project.              |
| `dt`   | `dotnet test`    | Run tests.                            |
| `dp`   | `dotnet pack`    | Pack into a `.nupkg`.                 |

### Watch mode

| Alias | Expansion           | Description             |
| ----- | ------------------- | ----------------------- |
| `dw`  | `dotnet watch`      | Watch for file changes. |
| `dwr` | `dotnet watch run`  | Watch + run.            |
| `dwt` | `dotnet watch test` | Watch + test.           |

### Solution and packages

| Alias | Expansion      | Description              |
| ----- | -------------- | ------------------------ |
| `ds`  | `dotnet sln`   | Manage solution files.   |
| `da`  | `dotnet add`   | Add package / reference. |
| `dng` | `dotnet nuget` | NuGet sub-commands.      |

## REQUIREMENTS

- `dotnet` SDK on `$PATH`.

## EXAMPLES

```bash
dn console -n Hello
cd Hello
dres && db
dr
dwt
da package Newtonsoft.Json
```

## SEE ALSO

- [.docs/README.md](../README.md)
