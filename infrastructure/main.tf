terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "6.3.1"
    }
  }
}

provider "github" {}

variable "code_freeze_status" {
  type = string
  description = "The status of the code Freeze" 
  validation {
    condition = contains(["active", "inactive"], var.code_freeze_status)
    error_message = "Code Freeze Status can only be active or inactive"
  }
}

resource "github_repository_ruleset" "this" {
  name       = "Code Freeze"
  repository = "tmp"

  target      = "branch"
  enforcement = var.code_freeze_status == "active" ? "active" : "disabled"

  conditions {
    ref_name {
      exclude = []
      include = [
        "~DEFAULT_BRANCH",
      ]
    }
  }


  rules {
    creation                      = false
    deletion                      = false
    non_fast_forward              = true
    required_linear_history       = false
    required_signatures           = false
    update                        = false
    update_allows_fetch_and_merge = false

    pull_request {
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_approving_review_count   = 10
      required_review_thread_resolution = false
    }
  }
}

import {
  to = github_repository_ruleset.this
  id = "tmp:2493528"
}
