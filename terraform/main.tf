provider "aws" {
  region = var.region

  default_tags {
    tags = {
      project     = "orbitly"
      environment = var.environment
      managed_by  = "terraform"
    }
  }
}

locals {
  name = "orbitly-${var.environment}"
}

module "network" {
  source = "./modules/network"

  name               = local.name
  cidr               = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "k8s_cluster" {
  source = "./modules/k8s_cluster"

  name                = local.name
  cluster_version     = var.cluster_version
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
}

module "postgres" {
  source = "./modules/postgres"

  name                       = local.name
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnet_ids
  allowed_security_group_ids = [module.k8s_cluster.node_security_group_id]
  instance_class             = var.db_instance_class
  multi_az                   = var.db_multi_az
  allocated_storage_gb       = var.db_allocated_storage_gb
}

data "aws_eks_cluster_auth" "this" {
  name = module.k8s_cluster.cluster_name
}

provider "kubernetes" {
  host                   = module.k8s_cluster.endpoint
  cluster_ca_certificate = base64decode(module.k8s_cluster.certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token
}

resource "kubernetes_namespace_v1" "orbitly" {
  metadata {
    name = "orbitly"
  }
}

# The backend and worker deployments read DATABASE_URL from this secret
# (see k8s/backend-deployment.yaml and k8s/worker-deployment.yaml).
resource "kubernetes_secret_v1" "orbitly_db" {
  metadata {
    name      = "orbitly-db"
    namespace = kubernetes_namespace_v1.orbitly.metadata[0].name
  }

  data = {
    DATABASE_URL = module.postgres.database_url
  }
}
