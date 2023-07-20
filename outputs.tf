output "variable_group" {
  description = "Outputs all attributes of resource_type."
  value = {
    for variable_group in keys(azuredevops_variable_group.variable_group) :
    variable_group => {
      for key, value in azuredevops_variable_group.variable_group[variable_group] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      variable_group = {
        for key in keys(var.variable_group) :
        key => local.variable_group[key]
      }
    }
  }
}
