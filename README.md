# Kong Cluster Terraform Module for AWS

:warning: This terraform module serves as reference point for getting started.
While it may work for certain scenarios, it is NOT intended to work with
all setups. Please fork the repo or copy over code from here
(liberal Apache-licensed).

[Kong API Gateway](https://konghq.com/) is an API gateway microservices
management layer. Both Kong and Enterprise Edition are supported.

By default, the following resources will be provisioned:

- RDS PostgreSQL database for Kong's configuration store
- An Auto Scaling Group (ASG) and EC2 instances running Kong (Kong nodes)
- An external load balancer (HTTPS only)
  - HTTPS:443 - Kong Proxy
- An internal load balancer (HTTP and HTTPS)
  - HTTP:80 - Kong Proxy
  - HTTPS:443 - Kong Proxy
  - HTTPS:8444 - Kong Admin API (Enterprise Edition only)
  - HTTPS:8445 - Kong Manager (Enterprise Edition only)
  - HTTPS:8446 - Kong Dev Portal GUI (Enterprise Edition only)
  - HTTPS:8447 - Kong Dev Portal API (Enterprise Edition only)
- Security groups granting least privilege access to resources
- An IAM instance profile for access to Kong specific SSM Parameter Store
  metadata and secrets

Optionally, a redis cluster can be provisioned for rate-limiting counters and
caching, and most default resources can be disabled.  See variables.tf for a
complete list and description of tunables.

The Kong nodes are based on [Minimal Ubuntu](https://wiki.ubuntu.com/Minimal).
Using cloud-init, the following is provisioned on top of the AMI:

- A kong service user
- Minimal set of dependencies and debugging tools
- decK for Kong declarative configuration management
- Kong, running under runit process supervision
- Log rotation of Kong log files

Prerequisites:

- An AWS VPC
- Private and public subnets tagged with a subnet_tag (default = 'Tier' tag)
- Database subnet group
- Cache subnet group (if enabling Redis)
- An SSH Key
- An SSL managed certificate to associate with HTTPS load balancers


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.42.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.42.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kong_external_lb_cw"></a> [kong\_external\_lb\_cw](#module\_kong\_external\_lb\_cw) | ./modules/lb | n/a |
| <a name="module_kong_internal_lb_cw"></a> [kong\_internal\_lb\_cw](#module\_kong\_internal\_lb\_cw) | ./modules/lb | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/autoscaling_group) | resource |
| [aws_db_instance.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/db_parameter_group) | resource |
| [aws_elasticache_parameter_group.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/elasticache_replication_group) | resource |
| [aws_iam_instance_profile.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.kong-ssm](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/kms_alias) | resource |
| [aws_kms_key.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/kms_key) | resource |
| [aws_launch_configuration.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/launch_configuration) | resource |
| [aws_lb.external](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb) | resource |
| [aws_lb.internal](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb) | resource |
| [aws_lb_listener.admin](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.external-https](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.internal-http](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.internal-https](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.manager](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.portal](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.portal-gui](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.admin](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.external](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.internal](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.manager](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.portal](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.portal-gui](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/lb_target_group) | resource |
| [aws_rds_cluster.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_security_group.external-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group) | resource |
| [aws_security_group.internal-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group) | resource |
| [aws_security_group.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group) | resource |
| [aws_security_group.postgresql](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group) | resource |
| [aws_security_group.redis](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.admin-ingress-bastion](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.admin-ingress-external-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.admin-ingress-internal-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.external-lb-egress-admin](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.external-lb-egress-proxy](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.external-lb-ingress-proxy](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-egress-admin](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-egress-manager](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-egress-portal](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-egress-portal-gui](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-egress-proxy](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-ingress-admin](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-ingress-manager](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-ingress-portal](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-ingress-portal-gui](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-ingress-proxy-http](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.internal-lb-ingress-proxy-https](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.kong-egress-http](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.kong-egress-https](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.manager-ingress-internal-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.portal-gui-ingress-internal-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.portal-ingress-internal-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.postgresql-ingress-bastion](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.postgresql-ingress-kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.proxy-ingress-external-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.proxy-ingress-internal-lb](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.redis-ingress-bastion](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.redis-ingress-kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.db-host](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.db-master-password](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.db-name](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.db-password](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ee-admin-token](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ee-bintray-auth](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.ee-license](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/resources/ssm_parameter) | resource |
| [random_string.admin_token](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/string) | resource |
| [random_string.db_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/string) | resource |
| [random_string.master_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/string) | resource |
| [random_string.session_secret](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/string) | resource |
| [aws_acm_certificate.admin-cert](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/acm_certificate) | data source |
| [aws_acm_certificate.external-cert](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/acm_certificate) | data source |
| [aws_acm_certificate.internal-cert](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/acm_certificate) | data source |
| [aws_acm_certificate.manager-cert](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/acm_certificate) | data source |
| [aws_acm_certificate.portal-cert](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/acm_certificate) | data source |
| [aws_iam_policy_document.kong](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kong-ssm](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/region) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/security_group) | data source |
| [aws_subnet_ids.private](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.public](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/3.42.0/docs/data-sources/vpc) | data source |
| [template_cloudinit_config.cloud-init](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/cloudinit_config) | data source |
| [template_file.cloud-init](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |
| [template_file.shell-script](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_cidr_blocks"></a> [admin\_cidr\_blocks](#input\_admin\_cidr\_blocks) | Access to Kong Admin API (Enterprise Edition only) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The number of instances that should be running in the group | `string` | `2` | no |
| <a name="input_asg_health_check_grace_period"></a> [asg\_health\_check\_grace\_period](#input\_asg\_health\_check\_grace\_period) | Time in seconds after instance comes into service before checking health | `string` | `300` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | The maximum size of the auto scale group | `string` | `3` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | The minimum size of the auto scale group | `string` | `1` | no |
| <a name="input_bastion_cidr_blocks"></a> [bastion\_cidr\_blocks](#input\_bastion\_cidr\_blocks) | Bastion hosts allowed access to PostgreSQL and Kong Admin | `list(string)` | <pre>[<br>  "127.0.0.1/32"<br>]</pre> | no |
| <a name="input_ce_pkg"></a> [ce\_pkg](#input\_ce\_pkg) | Filename of the Community Edition package | `string` | `"kong-1.5.0.bionic.amd64.deb"` | no |
| <a name="input_cloudwatch_actions"></a> [cloudwatch\_actions](#input\_cloudwatch\_actions) | List of cloudwatch actions for Alert/Ok | `list(string)` | `[]` | no |
| <a name="input_db_backup_retention_period"></a> [db\_backup\_retention\_period](#input\_db\_backup\_retention\_period) | The number of days to retain backups | `string` | `7` | no |
| <a name="input_db_engine_mode"></a> [db\_engine\_mode](#input\_db\_engine\_mode) | Engine mode for Aurora | `string` | `"provisioned"` | no |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | Database engine version | `string` | `"11.4"` | no |
| <a name="input_db_family"></a> [db\_family](#input\_db\_family) | Database parameter group family | `string` | `"postgres11"` | no |
| <a name="input_db_final_snapshot_identifier"></a> [db\_final\_snapshot\_identifier](#input\_db\_final\_snapshot\_identifier) | The final snapshot name of the RDS instance when it gets destroyed | `string` | `""` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | Database instance class | `string` | `"db.t2.micro"` | no |
| <a name="input_db_instance_count"></a> [db\_instance\_count](#input\_db\_instance\_count) | Number of database instances (0 to leverage an existing db) | `string` | `1` | no |
| <a name="input_db_multi_az"></a> [db\_multi\_az](#input\_db\_multi\_az) | Boolean to specify if RDS is multi-AZ | `string` | `false` | no |
| <a name="input_db_storage_size"></a> [db\_storage\_size](#input\_db\_storage\_size) | Size of the database storage in Gigabytes | `string` | `100` | no |
| <a name="input_db_storage_type"></a> [db\_storage\_type](#input\_db\_storage\_type) | Type of the database storage | `string` | `"gp2"` | no |
| <a name="input_db_subnets"></a> [db\_subnets](#input\_db\_subnets) | Database instance subnet group name | `string` | `"db-subnets"` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Database master username | `string` | `"root"` | no |
| <a name="input_deck_version"></a> [deck\_version](#input\_deck\_version) | Version of decK to install | `string` | `"1.0.0"` | no |
| <a name="input_default_security_group"></a> [default\_security\_group](#input\_default\_security\_group) | Name of the default VPC security group for EC2 access | `string` | `"default"` | no |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | Seconds to wait before changing the state of a deregistering target from draining to unused | `string` | `300` | no |
| <a name="input_description"></a> [description](#input\_description) | Resource description tag | `string` | `"Kong API Gateway"` | no |
| <a name="input_ec2_ami"></a> [ec2\_ami](#input\_ec2\_ami) | Map of Ubuntu Minimal AMIs by region | `map(string)` | <pre>{<br>  "eu-central-1": "ami-0cbcfdbe2416ea8df",<br>  "eu-west-1": "ami-0eb00845cbc30b475",<br>  "us-east-1": "ami-097f2dec72be3d174",<br>  "us-east-2": "ami-0ba142a7063a73767",<br>  "us-west-1": "ami-07b69f5dcdbb4abaf",<br>  "us-west-2": "ami-028b81a9f357b2b96"<br>}</pre> | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | EC2 instance type | `string` | `"t2.micro"` | no |
| <a name="input_ec2_key_name"></a> [ec2\_key\_name](#input\_ec2\_key\_name) | AWS SSH Key | `string` | `""` | no |
| <a name="input_ec2_root_volume_size"></a> [ec2\_root\_volume\_size](#input\_ec2\_root\_volume\_size) | Size of the root volume (in Gigabytes) | `string` | `8` | no |
| <a name="input_ec2_root_volume_type"></a> [ec2\_root\_volume\_type](#input\_ec2\_root\_volume\_type) | Type of the root volume (standard, gp2, or io) | `string` | `"gp2"` | no |
| <a name="input_ee_bintray_auth"></a> [ee\_bintray\_auth](#input\_ee\_bintray\_auth) | Bintray authentication for the Enterprise Edition download (Format: username:apikey) | `string` | `"placeholder"` | no |
| <a name="input_ee_license"></a> [ee\_license](#input\_ee\_license) | Enterprise Edition license key (JSON format) | `string` | `"placeholder"` | no |
| <a name="input_ee_pkg"></a> [ee\_pkg](#input\_ee\_pkg) | Filename of the Enterprise Edition package | `string` | `"kong-enterprise-edition-1.3.0.1.bionic.all.deb "` | no |
| <a name="input_enable_aurora"></a> [enable\_aurora](#input\_enable\_aurora) | Boolean to enable Aurora | `string` | `"false"` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Boolean to enable delete protection on the ALB | `string` | `true` | no |
| <a name="input_enable_ee"></a> [enable\_ee](#input\_enable\_ee) | Boolean to enable Kong Enterprise Edition settings | `string` | `false` | no |
| <a name="input_enable_external_lb"></a> [enable\_external\_lb](#input\_enable\_external\_lb) | Boolean to enable/create the external load balancer, exposing Kong to the Internet | `string` | `true` | no |
| <a name="input_enable_internal_lb"></a> [enable\_internal\_lb](#input\_enable\_internal\_lb) | Boolean to enable/create the internal load balancer for the forward proxy | `string` | `true` | no |
| <a name="input_enable_redis"></a> [enable\_redis](#input\_enable\_redis) | Boolean to enable redis AWS resource | `string` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Resource environment tag (i.e. dev, stage, prod) | `string` | n/a | yes |
| <a name="input_external_cidr_blocks"></a> [external\_cidr\_blocks](#input\_external\_cidr\_blocks) | External ingress access to Kong Proxy via the load balancer | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_health_check_healthy_threshold"></a> [health\_check\_healthy\_threshold](#input\_health\_check\_healthy\_threshold) | Number of consecutives checks before a unhealthy target is considered healthy | `string` | `5` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | Seconds between health checks | `string` | `5` | no |
| <a name="input_health_check_matcher"></a> [health\_check\_matcher](#input\_health\_check\_matcher) | HTTP Code(s) that result in a successful response from a target (comma delimited) | `string` | `200` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | Seconds waited before a health check fails | `string` | `3` | no |
| <a name="input_health_check_unhealthy_threshold"></a> [health\_check\_unhealthy\_threshold](#input\_health\_check\_unhealthy\_threshold) | Number of consecutive checks before considering a target unhealthy | `string` | `2` | no |
| <a name="input_http_4xx_count"></a> [http\_4xx\_count](#input\_http\_4xx\_count) | HTTP Code 4xx count threshhold | `string` | `50` | no |
| <a name="input_http_5xx_count"></a> [http\_5xx\_count](#input\_http\_5xx\_count) | HTTP Code 5xx count threshhold | `string` | `50` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | Seconds a connection can idle before being disconnected | `string` | `60` | no |
| <a name="input_internal_http_cidr_blocks"></a> [internal\_http\_cidr\_blocks](#input\_internal\_http\_cidr\_blocks) | Internal ingress access to Kong Proxy via the load balancer (HTTP) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_internal_https_cidr_blocks"></a> [internal\_https\_cidr\_blocks](#input\_internal\_https\_cidr\_blocks) | Internal ingress access to Kong Proxy via the load balancer (HTTPS) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_manager_cidr_blocks"></a> [manager\_cidr\_blocks](#input\_manager\_cidr\_blocks) | Access to Kong Manager (Enterprise Edition only) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_manager_host"></a> [manager\_host](#input\_manager\_host) | Hostname to access Kong Manager (Enterprise Edition only) | `string` | `"default"` | no |
| <a name="input_portal_cidr_blocks"></a> [portal\_cidr\_blocks](#input\_portal\_cidr\_blocks) | Access to Portal (Enterprise Edition only) | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_portal_host"></a> [portal\_host](#input\_portal\_host) | Hostname to access Portal (Enterprise Edition only) | `string` | `"default"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Subnet tag on private subnets | `string` | `"private"` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Subnet tag on public subnets for external load balancers | `string` | `"public"` | no |
| <a name="input_redis_engine_version"></a> [redis\_engine\_version](#input\_redis\_engine\_version) | Redis engine version | `string` | `"5.0.5"` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | Redis parameter group family | `string` | `"redis5.0"` | no |
| <a name="input_redis_instance_count"></a> [redis\_instance\_count](#input\_redis\_instance\_count) | Number of redis nodes | `string` | `2` | no |
| <a name="input_redis_instance_type"></a> [redis\_instance\_type](#input\_redis\_instance\_type) | Redis node instance type | `string` | `"cache.t2.small"` | no |
| <a name="input_redis_subnets"></a> [redis\_subnets](#input\_redis\_subnets) | Redis cluster subnet group name | `string` | `"cache-subnets"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Resource service tag | `string` | `"kong"` | no |
| <a name="input_ssl_cert_admin"></a> [ssl\_cert\_admin](#input\_ssl\_cert\_admin) | SSL certificate domain name for the Kong Admin API HTTPS listener | `string` | n/a | yes |
| <a name="input_ssl_cert_external"></a> [ssl\_cert\_external](#input\_ssl\_cert\_external) | SSL certificate domain name for the external Kong Proxy HTTPS listener | `string` | n/a | yes |
| <a name="input_ssl_cert_internal"></a> [ssl\_cert\_internal](#input\_ssl\_cert\_internal) | SSL certificate domain name for the internal Kong Proxy HTTPS listener | `string` | n/a | yes |
| <a name="input_ssl_cert_manager"></a> [ssl\_cert\_manager](#input\_ssl\_cert\_manager) | SSL certificate domain name for the Kong Manager HTTPS listener | `string` | n/a | yes |
| <a name="input_ssl_cert_portal"></a> [ssl\_cert\_portal](#input\_ssl\_cert\_portal) | SSL certificate domain name for the Dev Portal listener | `string` | n/a | yes |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | SSL Policy for HTTPS Listeners | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| <a name="input_subnet_tag"></a> [subnet\_tag](#input\_subnet\_tag) | Tag used on subnets to define Tier | `string` | `"Tier"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_token"></a> [admin\_token](#output\_admin\_token) | The admin token for Kong |
| <a name="output_lb_endpoint_external"></a> [lb\_endpoint\_external](#output\_lb\_endpoint\_external) | The external load balancer endpoint |
| <a name="output_lb_endpoint_internal"></a> [lb\_endpoint\_internal](#output\_lb\_endpoint\_internal) | The internal load balancer endpoint |
| <a name="output_master_password"></a> [master\_password](#output\_master\_password) | The master password for Kong |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | The endpoint for the Kong database |
| <a name="output_rds_password"></a> [rds\_password](#output\_rds\_password) | The database password for Kong |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Information



## Policy

This is the policy required to build this project:

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
resource "aws_iam_policy" "terraform_pike" {
  name_prefix = "terraform_pike"
  path        = "/"
  description = "Pike Autogenerated policy from IAC"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "autoscaling:CreateAutoScalingGroup",
                "autoscaling:CreateLaunchConfiguration",
                "autoscaling:DeleteAutoScalingGroup",
                "autoscaling:DeleteLaunchConfiguration",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:UpdateAutoScalingGroup"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DeleteAlarms",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:ListTagsForResource",
                "cloudwatch:PutMetricAlarm"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteTags",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeImages",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcs",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "elasticache:AddTagsToResource",
                "elasticache:CreateCacheParameterGroup",
                "elasticache:CreateReplicationGroup",
                "elasticache:DeleteCacheParameterGroup",
                "elasticache:DeleteReplicationGroup",
                "elasticache:DescribeCacheParameterGroups",
                "elasticache:DescribeCacheParameters",
                "elasticache:DescribeReplicationGroups",
                "elasticache:ListTagsForResource",
                "elasticache:ModifyCacheParameterGroup",
                "elasticache:ModifyReplicationGroup",
                "elasticache:RemoveTagsFromResource"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:SetSecurityGroups"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor5",
            "Effect": "Allow",
            "Action": [
                "iam:AddRoleToInstanceProfile",
                "iam:CreateInstanceProfile",
                "iam:CreateRole",
                "iam:DeleteInstanceProfile",
                "iam:DeleteRole",
                "iam:DeleteRolePolicy",
                "iam:GetInstanceProfile",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:ListRolePolicies",
                "iam:PassRole",
                "iam:PutRolePolicy",
                "iam:RemoveRoleFromInstanceProfile"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor6",
            "Effect": "Allow",
            "Action": [
                "kms:CreateAlias",
                "kms:CreateKey",
                "kms:Decrypt",
                "kms:DeleteAlias",
                "kms:DescribeKey",
                "kms:EnableKeyRotation",
                "kms:Encrypt",
                "kms:GetKeyPolicy",
                "kms:GetKeyRotationStatus",
                "kms:ListAliases",
                "kms:ListResourceTags",
                "kms:ScheduleKeyDeletion",
                "kms:TagResource",
                "kms:UntagResource"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor7",
            "Effect": "Allow",
            "Action": [
                "rds:AddTagsToResource",
                "rds:CreateDBCluster",
                "rds:CreateDBClusterParameterGroup",
                "rds:CreateDBInstance",
                "rds:CreateDBParameterGroup",
                "rds:DeleteDBCluster",
                "rds:DeleteDBClusterParameterGroup",
                "rds:DeleteDBParameterGroup",
                "rds:DescribeDBClusterParameterGroups",
                "rds:DescribeDBClusterParameters",
                "rds:DescribeDBClusters",
                "rds:DescribeDBInstances",
                "rds:DescribeDBParameterGroups",
                "rds:DescribeDBParameters",
                "rds:DescribeGlobalClusters",
                "rds:ListTagsForResource",
                "rds:ModifyDBCluster",
                "rds:ModifyDBClusterParameterGroup",
                "rds:ModifyDBInstance",
                "rds:ModifyDBParameterGroup",
                "rds:RemoveTagsFromResource"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor8",
            "Effect": "Allow",
            "Action": [
                "ssm:AddTagsToResource",
                "ssm:DeleteParameter",
                "ssm:DescribeParameters",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListTagsForResource",
                "ssm:PutParameter"
            ],
            "Resource": "*"
        }
    ]
})
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->
