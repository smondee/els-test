variable "project_name" {
  type    = string
  default = "edion"
}
variable "service_name" {
  type    = string
  default = "elssite"
}

locals {
  env                     = "stg"
  env_long                = "staging"
  resource_prefix         = "${var.project_name}-${var.service_name}-${local.env}"
  resource_prefix_short   = "${var.service_name}-${local.env}"
  service_domain          = ""
  vpc_cidr                = "10.125.0.0/16" # NEW_EC_INFRA-17
  edion_system_cloud_cidr = "10.117.0.0/16" # NEW_EC_INFRA-3 transit gateway接続先
  tgw_cidr                = "10.67.0.0/16"

  availability_zones = {
    0 = "${data.aws_region.current.name}a"
    1 = "${data.aws_region.current.name}c"
    # 2 = "${data.aws_region.current.name}d"
  }

  /* IP情報 */
#  source_ip_address_nat_gateway = [
#    "${data.aws_nat_gateway.main["public_a"].public_ip}/32",
#  ]

#  source_ip_address_hampstead = [
#    "150.249.199.195/32", # 品川拠点 NEW_EC_INFRA-1
#  ]

  source_ip_address_edion_PC_Head_Store = [ # NEW_EC_INFRA-44
    "208.127.162.8/32",                     # PC用	Japan Central	NIC	本部・店舗
    "34.98.170.39/32",                      # PC用	Japan South	NIC	本部・店舗
    "34.98.169.182/32",                     # PC用	Japan South	アネックス、JR尼崎駅店	店舗
    "34.98.169.183/32",                     # PC用	Japan South	NIC	本部・店舗
    "208.127.162.205/32",                   # PC用	Japan South	尼崎（情シス） 海田店	本部
    "137.83.213.235/32",                    # PC用	Japan South	中之島本社	本部
    "137.83.213.236/32",                    # PC用	Japan South	中之島本社	本部
    "137.83.213.220/32",                    # PC用	Japan South	尼崎（ELSほか）	本部
    "137.83.215.87/32",                     # PC用	Japan South	NIC	本部・店舗
    "137.83.215.86/32",                     # PC用	Japan South	NIC	本部・店舗
  ]
  source_ip_address_edion_PC_GP = [ # NEW_EC_INFRA-44
    "34.98.173.200/32",             # PC用	Japan Central	GP	GP
    "34.98.161.90/32",              # PC用	Japan Central	GP	GP
    "134.238.5.117/32",             # PC用	Japan Central	GP	GP
    "134.238.6.178/32",             # PC用	Japan Central	GP	GP
    "34.98.170.32/32",              # PC用	Japan South	GP	GP
    "34.100.104.182/32",            # PC用	Japan South	GP	GP
    "134.238.3.29/32",              # PC用	Japan South	GP	GP
    "134.238.3.105/32",             # PC用	Japan South	GP	GP
    "134.238.3.107/32",             # PC用	Japan South	GP	GP
    "134.238.3.28/32",              # PC用	Japan South	GP	GP
    "34.98.172.113/32",             # PC用	Japan South	GP	GP
    "66.159.200.62/32",             # PC用	Japan South	GP	GP
    "208.127.162.33/32",            # PC用	Japan South	GP	GP
    "34.98.172.114/32",             # PC用	Japan South	GP	GP
    "208.127.162.44/32",            # PC用	Japan South	GP	GP
    "208.127.162.54/32",            # PC用	Japan South	GP	GP
    "208.127.162.3/32",             # PC用	Japan South	GP	GP
    "208.127.162.53/32",            # PC用	Japan South	GP	GP
    "208.127.162.51/32",            # PC用	Japan South	GP	GP
    "208.127.162.49/32",            # PC用	Japan South	GP	GP
    "208.127.162.34/32",            # PC用	Japan South	GP	GP
    "34.98.161.89/32",              # PC用	Japan South	GP	GP
    "208.127.84.23/32",             # PC用	US West	GP	GP
    "208.127.84.230/32",            # PC用	US West	GP	GP
  ]
  source_ip_address_edion_Mobile_GP = [ # NEW_EC_INFRA-44
    "34.98.173.126/32",                 # モバイル用	Japan Central	GP	GP
    "34.98.161.95/32",                  # モバイル用	Japan Central	GP	GP
    "134.238.6.160/32",                 # モバイル用	Japan Central	GP	GP
    "134.238.5.119/32",                 # モバイル用	Japan Central	GP	GP
    "34.98.169.184/32",                 # モバイル用	Japan South	GP	GP
    "34.100.104.184/32",                # モバイル用	Japan South	GP	GP
    "34.98.170.3/32",                   # モバイル用	Japan South	GP	GP
    "34.100.104.183/32",                # モバイル用	Japan South	GP	GP
    "34.98.161.92/32",                  # モバイル用	Japan South	GP	GP
    "34.98.172.115/32",                 # モバイル用	Japan South	GP	GP
    "208.127.84.231/32",                # モバイル用	US West	GP	GP
    "208.127.84.232/32",                # モバイル用	US West	GP	GP
  ]
  source_ip_address_edion_test_client = [ # NEW_EC-568
    "153.156.194.215/32"
  ]

  domains = {
    #private = "${var.project_name}.${local.env}.local"
    private = "${local.env}.${var.project_name}sys1.internal"
    service = "edion.com"
  }
}

