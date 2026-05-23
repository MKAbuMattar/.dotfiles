# huaweicloud-aliases

## NAME

**huaweicloud-aliases** — short aliases for the Huawei Cloud `hcloud` CLI covering ECS, VPC, OBS, IAM, RDS, CCE, DNS, ELB, and configuration.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "huaweicloud" ...)
```

## DESCRIPTION

Provides short prefixed aliases (`hc*`) over the Huawei Cloud `hcloud` CLI for the most common service families: Elastic Cloud Server (ECS), Virtual Private Cloud (VPC), Object Storage Service (OBS), Identity and Access Management (IAM), Relational Database Service (RDS), Cloud Container Engine (CCE), Domain Name Service (DNS), Elastic Load Balance (ELB), plus configuration, regions, and availability zones. The module is gated by `(( ! $+commands[hcloud] )) && return`, so it loads only when the `hcloud` binary is available on `$PATH`.

## ALIASES

### General

| Alias | Expansion        | Description                 |
| ----- | ---------------- | --------------------------- |
| `hc`  | `hcloud`         | Invoke the Huawei Cloud CLI |
| `hcv` | `hcloud version` | Show CLI version            |
| `hcl` | `hcloud list`    | Generic list command        |

### Compute (ECS)

| Alias         | Expansion             | Description              |
| ------------- | --------------------- | ------------------------ |
| `hcecs`       | `hcloud ecs`          | ECS service entry        |
| `hcecsl`      | `hcloud ecs list`     | List ECS instances       |
| `hcecsd`      | `hcloud ecs describe` | Describe an ECS instance |
| `hcecsc`      | `hcloud ecs create`   | Create an ECS instance   |
| `hcecsdel`    | `hcloud ecs delete`   | Delete an ECS instance   |
| `hcecsstart`  | `hcloud ecs start`    | Start an ECS instance    |
| `hcecsstop`   | `hcloud ecs stop`     | Stop an ECS instance     |
| `hcecsreboot` | `hcloud ecs reboot`   | Reboot an ECS instance   |

### Virtual Private Cloud (VPC)

| Alias      | Expansion             | Description       |
| ---------- | --------------------- | ----------------- |
| `hcvpc`    | `hcloud vpc`          | VPC service entry |
| `hcvpcl`   | `hcloud vpc list`     | List VPCs         |
| `hcvpcd`   | `hcloud vpc describe` | Describe a VPC    |
| `hcvpcc`   | `hcloud vpc create`   | Create a VPC      |
| `hcvpcdel` | `hcloud vpc delete`   | Delete a VPC      |

### Object Storage (OBS)

| Alias       | Expansion         | Description               |
| ----------- | ----------------- | ------------------------- |
| `hcobs`     | `hcloud obs`      | OBS service entry         |
| `hcobsl`    | `hcloud obs list` | List buckets/objects      |
| `hcobsmb`   | `hcloud obs mb`   | Make bucket               |
| `hcobsrb`   | `hcloud obs rb`   | Remove bucket             |
| `hcobscp`   | `hcloud obs cp`   | Copy objects              |
| `hcobssync` | `hcloud obs sync` | Sync directories with OBS |

### Identity and Access Management (IAM)

| Alias      | Expansion             | Description              |
| ---------- | --------------------- | ------------------------ |
| `hciam`    | `hcloud iam`          | IAM service entry        |
| `hciaml`   | `hcloud iam list`     | List IAM resources       |
| `hciamd`   | `hcloud iam describe` | Describe an IAM resource |
| `hciamc`   | `hcloud iam create`   | Create an IAM resource   |
| `hciamdel` | `hcloud iam delete`   | Delete an IAM resource   |

### Relational Database Service (RDS)

| Alias      | Expansion             | Description              |
| ---------- | --------------------- | ------------------------ |
| `hcrds`    | `hcloud rds`          | RDS service entry        |
| `hcrdsl`   | `hcloud rds list`     | List RDS instances       |
| `hcrdsd`   | `hcloud rds describe` | Describe an RDS instance |
| `hcrdsc`   | `hcloud rds create`   | Create an RDS instance   |
| `hcrdsdel` | `hcloud rds delete`   | Delete an RDS instance   |

### Cloud Container Engine (CCE)

| Alias      | Expansion             | Description            |
| ---------- | --------------------- | ---------------------- |
| `hccce`    | `hcloud cce`          | CCE service entry      |
| `hcccel`   | `hcloud cce list`     | List CCE clusters      |
| `hcccec`   | `hcloud cce create`   | Create a CCE cluster   |
| `hcccedel` | `hcloud cce delete`   | Delete a CCE cluster   |
| `hccced`   | `hcloud cce describe` | Describe a CCE cluster |

### Domain Name Service (DNS)

| Alias      | Expansion           | Description              |
| ---------- | ------------------- | ------------------------ |
| `hcdns`    | `hcloud dns`        | DNS service entry        |
| `hcdnsl`   | `hcloud dns list`   | List DNS resources       |
| `hcdnsc`   | `hcloud dns create` | Create a DNS record/zone |
| `hcdnsdel` | `hcloud dns delete` | Delete a DNS record/zone |

### Elastic Load Balance (ELB)

| Alias      | Expansion           | Description            |
| ---------- | ------------------- | ---------------------- |
| `hcelb`    | `hcloud elb`        | ELB service entry      |
| `hcelbl`   | `hcloud elb list`   | List load balancers    |
| `hcelbc`   | `hcloud elb create` | Create a load balancer |
| `hcelbdel` | `hcloud elb delete` | Delete a load balancer |

### Configuration

| Alias       | Expansion               | Description               |
| ----------- | ----------------------- | ------------------------- |
| `hcconf`    | `hcloud configure`      | Configure the CLI         |
| `hcconfl`   | `hcloud configure list` | List configuration        |
| `hcconfset` | `hcloud configure set`  | Set a configuration value |
| `hcconfget` | `hcloud configure get`  | Get a configuration value |

### Regions and Availability Zones

| Alias    | Expansion                       | Description             |
| -------- | ------------------------------- | ----------------------- |
| `hcreg`  | `hcloud region`                 | Region commands         |
| `hcregl` | `hcloud region list`            | List regions            |
| `hcaz`   | `hcloud availability-zone`      | AZ commands             |
| `hcazl`  | `hcloud availability-zone list` | List availability zones |

### Help

| Alias    | Expansion     | Description              |
| -------- | ------------- | ------------------------ |
| `hch`    | `hcloud help` | Show help                |
| `hchelp` | `hcloud help` | Show help (verbose form) |

## REQUIREMENTS

- `hcloud` (Huawei Cloud CLI) installed and on `$PATH`.
- A configured Huawei Cloud profile (run `hcconf` to set credentials and region).

## EXAMPLES

```bash
# List all ECS instances
hcecsl

# Describe a specific VPC
hcvpcd --vpc-id vpc-xxxxxxxx

# Sync a local directory to an OBS bucket
hcobssync ./build obs://my-bucket/static/

# Switch the configured region
hcconfset --cli-region=cn-north-4
```

## SEE ALSO

- [.docs/README.md](../README.md)
