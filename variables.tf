variable "variable_group" {
  type        = any
  default     = {}
  description = "Resource definition, default settings are defined within locals and merged with var settings. For more information look at [Outputs](#Outputs)."
}

locals {
  default = {
    // resource definition
    variable_group = {
      name         = ""
      description  = null
      allow_access = false // defined default
      variable = {
        name         = ""
        value        = null
        secret_value = null
        is_secret    = null
      }
      key_vault = {
        name         = ""
        search_depth = null
      }
    }
  }

  // compare and merge custom and default values
  variable_group_values = {
    for variable_group in keys(var.variable_group) :
    variable_group => merge(local.default.variable_group, var.variable_group[variable_group])
  }

  // deep merge of all custom and default values
  variable_group = {
    for variable_group in keys(var.variable_group) :
    variable_group => merge(
      local.variable_group_values[variable_group],
      {
        for config in ["variable", "key_vault"] :
        config => keys(local.variable_group_values[variable_group][config]) == keys(local.default.variable_group[config]) ? {} : {
          for key in keys(local.variable_group_values[variable_group][config]) :
          key => merge(local.default.variable_group[config], local.variable_group_values[variable_group][config][key])
        }
      }
    )
  }
}
