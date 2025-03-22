locals {
  repository = "paper2/google-cloud-restricts-github-actions-sample"
}

resource "google_iam_workload_identity_pool" "github_actions_pool" {
  project                   = var.project
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "github-actions-pool"
  description               = "Workload Identity Pool for GitHub Actions"
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "github_actions_workflow_pool_provider" {
  project                            = var.project
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name                       = "github-actions-provider"
  description                        = "Workload Identity Pool Provider for GitHub Actions"
  disabled                           = false
  attribute_condition                = "'${local.repository}' == attribute.repository"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_project_iam_member" "github_actions" {
  project = var.project
  for_each = toset([
    // 付与するロールを列挙
    "roles/run.developer"
  ])
  role = each.value
  // Direct Workload Identity Federationでは、`Environment`を利用している場合はsubjectに指定する必要がある。
  member = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions_pool.name}/subject/repo:${local.repository}:environment:${var.environment}"
}
