# flutter-aliases

## NAME

**flutter-aliases** — short prefixes for the Flutter SDK CLI.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "flutter" ...)
```

## DESCRIPTION

Three- to seven-character shortcuts for `flutter`, `flutter pub`, and the
common build modes (debug / profile / release). Aliases load
unconditionally — install the Flutter SDK and put `flutter` on `$PATH`.

## ALIASES

### Core

| Alias      | Expansion         | Description                         |
| ---------- | ----------------- | ----------------------------------- |
| `fl`       | `flutter`         | The bare CLI.                       |
| `fldoc`    | `flutter doctor`  | Diagnose the toolchain.             |
| `fldvcs`   | `flutter devices` | List connected devices / emulators. |
| `flchnl`   | `flutter channel` | Switch / display SDK channel.       |
| `flupgrd`  | `flutter upgrade` | Upgrade the SDK.                    |
| `flc`      | `flutter clean`   | Clean build outputs.                |
| `flb`      | `flutter build`   | Build for a target platform.        |
| `flattach` | `flutter attach`  | Attach to a running app.            |

### Run modes

| Alias  | Expansion               | Description    |
| ------ | ----------------------- | -------------- |
| `flr`  | `flutter run`           | Default run.   |
| `flrd` | `flutter run --debug`   | Debug build.   |
| `flrp` | `flutter run --profile` | Profile build. |
| `flrr` | `flutter run --release` | Release build. |

### Pub

| Alias   | Expansion         | Description                |
| ------- | ----------------- | -------------------------- |
| `flpub` | `flutter pub`     | Pub subcommand entrypoint. |
| `flget` | `flutter pub get` | Resolve & fetch deps.      |

## REQUIREMENTS

- `flutter` SDK on `$PATH`. `flutter doctor` should pass for the platforms
  you intend to target.

## EXAMPLES

```bash
fldoc
flget
flr -d chrome
flrr               # release build run
flb apk --split-per-abi
```

## SEE ALSO

- [.docs/README.md](../README.md)
