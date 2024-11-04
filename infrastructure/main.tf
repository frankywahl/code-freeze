terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.3.1"
    }
  }
}

locals {
  owner = var.github_repository != null ? split("/", var.github_repository)[0] : null
  repo  = var.github_repository != null ? split("/", var.github_repository)[1] : null
}

provider "github" {}

variable "code_freeze_status" {
  type        = string
  description = "The status of the code Freeze"
  validation {
    condition     = contains(["active", "inactive"], var.code_freeze_status)
    error_message = "Code Freeze Status can only be active or inactive"
  }
}

variable "github_repository" {
  type        = string
  description = "Name of the repositority, example owner/repo"

  validation {
    condition     = length(split("/", var.github_repository)) == 2
    error_message = "Repository name must be in the format owner/repo"
  }
}

variable "github_rule_id" {
  type        = number
  description = "The ID of the rule"
}

resource "github_repository_ruleset" "this" {
  name       = "Code Freeze"
  repository = local.repo

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
    update                        = var.code_freeze_status == "active" ? true : false
    update_allows_fetch_and_merge = false
  }
}

import {
  to = github_repository_ruleset.this
  id = "${local.repo}:${var.github_rule_id}"
}
