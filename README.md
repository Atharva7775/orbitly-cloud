# orbitly-cloud

Database schema, infrastructure and deployment manifests for **Orbitly**.

| Path | What |
| --- | --- |
| `db/schema.sql` | Current Postgres schema (users, products, sessions, orders, order_items, payments, cart_items) |
| `db/migrations/` | Ordered migrations; identical to `orbitly-backend/migrations/` |
| `db/seed.sql` | Demo catalog for local/QA |
| `terraform/` | AWS: VPC (`modules/network`), RDS Postgres (`modules/postgres`), EKS (`modules/k8s_cluster`) |
| `k8s/` | Deployments for `orbitly-frontend`, `orbitly-backend` (API + migrate init container), `orbitly-worker`, Redis, ingress |
| `docker-compose.yml` | Local full stack built from `../orbitly-frontend` and `../orbitly-backend` |
| `.gitlab-ci.yml` | Terraform validate/plan/apply and `kubectl apply -k k8s/` |

## Configuration contract

* `DATABASE_URL` — produced by Terraform (`output "database_url"`), stored in the `orbitly-db`
  Kubernetes secret and read by the backend, worker and migrate containers. Locally it is set in
  `docker-compose.yml`.
* `PAYMENTS_API_KEY` — created out of band in the `orbitly-payments` secret; never committed.

## Local stack

```bash
docker compose up --build
# storefront http://localhost:3000 · API http://localhost:8000/api/docs · mail http://localhost:8025
```

## Environments

| Branch | Environment | tfvars |
| --- | --- | --- |
| `main` | prod (us-east-1) | `envs/prod.tfvars` |
| `prod-eu` | prod-eu (eu-central-1) | `envs/prod-eu.tfvars` |
| `staging` | staging | `envs/staging.tfvars` |
| `qa` | qa | `envs/qa.tfvars` |
