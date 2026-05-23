#!/usr/bin/env zsh

# Do nothing if hcloud is not installed
(( ! $+commands[hcloud] )) && return

# General aliases
alias hc='hcloud'
alias hcv='hcloud version'
alias hcl='hcloud list'

# Compute (ECS) aliases
alias hcecs='hcloud ecs'
alias hcecsl='hcloud ecs list'
alias hcecsd='hcloud ecs describe'
alias hcecsc='hcloud ecs create'
alias hcecsdel='hcloud ecs delete'
alias hcecsstart='hcloud ecs start'
alias hcecsstop='hcloud ecs stop'
alias hcecsreboot='hcloud ecs reboot'

# Virtual Private Cloud (VPC) aliases
alias hcvpc='hcloud vpc'
alias hcvpcl='hcloud vpc list'
alias hcvpcd='hcloud vpc describe'
alias hcvpcc='hcloud vpc create'
alias hcvpcdel='hcloud vpc delete'

# Object Storage Service (OBS) aliases
alias hcobs='hcloud obs'
alias hcobsl='hcloud obs list'
alias hcobsmb='hcloud obs mb'
alias hcobsrb='hcloud obs rb'
alias hcobscp='hcloud obs cp'
alias hcobssync='hcloud obs sync'

# Identity and Access Management (IAM) aliases
alias hciam='hcloud iam'
alias hciaml='hcloud iam list'
alias hciamd='hcloud iam describe'
alias hciamc='hcloud iam create'
alias hciamdel='hcloud iam delete'

# Relational Database Service (RDS) aliases
alias hcrds='hcloud rds'
alias hcrdsl='hcloud rds list'
alias hcrdsd='hcloud rds describe'
alias hcrdsc='hcloud rds create'
alias hcrdsdel='hcloud rds delete'

# Container Cluster (CCE) aliases
alias hccce='hcloud cce'
alias hcccel='hcloud cce list'
alias hcccec='hcloud cce create'
alias hcccedel='hcloud cce delete'
alias hccced='hcloud cce describe'

# Domain Name Service (DNS) aliases
alias hcdns='hcloud dns'
alias hcdnsl='hcloud dns list'
alias hcdnsc='hcloud dns create'
alias hcdnsdel='hcloud dns delete'

# Elastic Load Balance (ELB) aliases
alias hcelb='hcloud elb'
alias hcelbl='hcloud elb list'
alias hcelbc='hcloud elb create'
alias hcelbdel='hcloud elb delete'

# Configuration aliases
alias hcconf='hcloud configure'
alias hcconfl='hcloud configure list'
alias hcconfset='hcloud configure set'
alias hcconfget='hcloud configure get'

# Region and availability zone
alias hcreg='hcloud region'
alias hcregl='hcloud region list'
alias hcaz='hcloud availability-zone'
alias hcazl='hcloud availability-zone list'

# Help and info
alias hch='hcloud help'
alias hchelp='hcloud help'
