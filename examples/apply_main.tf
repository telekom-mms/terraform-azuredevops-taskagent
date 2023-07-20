data "azurerm_subscription" "current" {}

module "core" {
  source = "registry.terraform.io/telekom-mms/core/azuredevops"
  project = {
    mms = {}
  }
}

module "taskagent" {
  source = "registry.terraform.io/telekom-mms/taskagent/azuredevops"
  variable_group = {
    azurerm = {
      project_id = module.core.project["mms"].id
      variable = {
        subscription_name = {
          value = data.azurerm_subscription.current.display_name
        }
      }
    }
  }
}
