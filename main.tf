/**
* # taskagent
*
* This module manages the microsoft/azuredevops taskagent resources, see https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs.
*
* For more information about the module structure see https://telekom-mms.github.io/terraform-template.
*
*/

resource "azuredevops_variable_group" "variable_group" {
  for_each = var.variable_group

  name         = local.variable_group[each.key].name == "" ? each.key : local.variable_group[each.key].name
  project_id   = local.variable_group[each.key].project_id
  description  = local.variable_group[each.key].description
  allow_access = local.variable_group[each.key].allow_access

  dynamic "variable" {
    for_each = local.variable_group[each.key].variable

    content {
      name         = local.variable_group[each.key].variable[variable.key].name == "" ? variable.key : local.variable_group[each.key].variable[variable.key].name
      value        = local.variable_group[each.key].variable[variable.key].value
      secret_value = local.variable_group[each.key].variable[variable.key].secret_value
      is_secret    = local.variable_group[each.key].variable[variable.key].is_secret
    }
  }

  dynamic "key_vault" {
    for_each = local.variable_group[each.key].key_vault

    content {
      name                = local.variable_group[each.key].key_vault[key_vault.key].name == "" ? key_vault.key : local.variable_group[each.key].key_vault[key_vault.key].name
      service_endpoint_id = local.variable_group[each.key].key_vault[key_vault.key].service_endpoint_id
      search_depth        = local.variable_group[each.key].key_vault[key_vault.key].search_depth
    }
  }
}
