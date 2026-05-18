output "vpc_id" {
  value = module.network.vpc_id
}

output "cluster_name" {
  value = module.k8s_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.k8s_cluster.endpoint
}

output "database_endpoint" {
  value = module.postgres.endpoint
}

output "database_url" {
  description = "SQLAlchemy URL consumed by orbitly-backend as DATABASE_URL."
  value       = module.postgres.database_url
  sensitive   = true
}
