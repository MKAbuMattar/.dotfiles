# prayer-times

## NAME

**prayer-times** — Islamic prayer schedule by city via the AlAdhan API.

## SYNOPSIS

```
prayer-times -c <city> -o <country> [-m <method>] [-f 12|24]
```

## DESCRIPTION

Fetches today's prayer times for a given city/country from the public
AlAdhan API. Prints a single-screen summary including the five daily prayers
(Fajr / Dhuhr / Asr / Maghrib / Isha) with their times, which prayer is
currently active and which is next, countdown until the next prayer, and
today's Hijri and Gregorian dates.

## OPTIONS

| Option            | Type    | Default | Description                                                  |
| ----------------- | ------- | ------- | ------------------------------------------------------------ |
| `-c`, `--city`    | string  | —       | Required. City name. Capitalization is normalized.           |
| `-o`, `--country` | string  | —       | Required. Country name.                                      |
| `-m`, `--method`  | integer | `1`     | AlAdhan calculation method. See "CALCULATION METHODS" below. |
| `-f`, `--format`  | enum    | `12`    | Time format: `12` (12-hour with am/pm) or `24` (HH:MM).      |
| `-h`, `--help`    | flag    | —       | Show help and exit.                                          |

### Calculation methods

| Code | Method                                  |
| ---- | --------------------------------------- |
| 1    | University of Islamic Sciences, Karachi |
| 2    | Islamic Society of North America (ISNA) |
| 3    | Muslim World League                     |
| 4    | Umm al-Qura, Makkah                     |
| 5    | Egyptian General Authority of Survey    |
| 8    | Gulf Region                             |
| 12   | Diyanet İşleri Başkanlığı, Turkey       |

See https://aladhan.com/calculation-methods for the full list.

## EXAMPLES

```bash
prayer-times -c Amman -o Jordan
prayer-times -c Toronto -o Canada -m 2 -f 24
```

## OUTPUT

A colorized, formatted block on stdout containing the heading, summary row,
the prayer table, and Hijri/Gregorian dates.

## EXIT STATUS

| Code | Meaning                                                   |
| ---- | --------------------------------------------------------- |
| 0    | Success                                                   |
| 1    | API error (non-200 response, network failure, JSON parse) |
| 2    | Invalid CLI arguments (argparse)                          |

## ENVIRONMENT

None.

## FILES

None. Stateless network call only.

## PLATFORMS

| Platform             | Supported | Notes              |
| -------------------- | --------- | ------------------ |
| Linux / macOS        | Yes       | Python 3.9+ stdlib |
| Windows (WSL/native) | Yes       | Same               |

## REQUIREMENTS

- Python 3.9+ (stdlib only).
- Outbound HTTP access to `api.aladhan.com`.

## SEE ALSO

- AlAdhan API — https://aladhan.com/prayer-times-api
- [.docs/README.md](../../README.md)
