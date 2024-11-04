# Code free sample

This repository creates an action to enable / disable pushing to the default branch.

## How to use this on a new repository:

1. Copy the .github/workflow/code-freeze.yml to your repository.
1. Create a rule in your repository
1. Update the .github.wokflow/code-freeze.yml environemnt variable the the rule_id you that was just created
1. Make sure to have a `GH_TOKEN` secret that is given sufficent permissions to Admin the Repository. Namely Repository Administration Read Write Access (can be created as a fine grained token).
1. Enjoy!
