# azure-aliases

## NAME

**azure-aliases** — minimal Azure CLI shortcut.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "azure" ...)
```

## DESCRIPTION

A single alias for switching the active Azure subscription. The module is
intentionally tiny — extend it locally as your workflow grows.

## ALIASES

### Account

| Alias  | Expansion                       | Description                                                                         |
| ------ | ------------------------------- | ----------------------------------------------------------------------------------- |
| `azss` | `az account set --subscription` | Set the active subscription. Pass the subscription ID or name as the next argument. |

## REQUIREMENTS

- `az` — the Azure CLI (`azure-cli` package, or install via Microsoft's
  installer). The module does not detect its presence; the alias will
  fail at run time if `az` is not on `$PATH`.

## EXAMPLES

```bash
azss "My Subscription"
azss 00000000-0000-0000-0000-000000000000
```

## SEE ALSO

- [.docs/README.md](../README.md)
