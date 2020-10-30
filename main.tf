resource "gitlab_group" "map" {
  for_each    = local.group_map
  name        = each.key
  path        = each.key
  description = each.value.description
}

resource "gitlab_user" "map" {
  for_each         = local.users_map
  name             = each.key
  username         = each.value.username
  email            = each.value.email
  is_admin         = each.value.is_admin
  password         = each.value.password
  depends_on       = [gitlab_group.map]
}

resource "gitlab_group_membership" "map" {
  for_each     = local.user_group_map
  # Gets group id given group name
  group_id     = gitlab_group.map[each.value.group_name].id
  # Gets user id given user name
  user_id      = gitlab_user.map[each.value.user_name].id
  access_level = each.value.access
  depends_on       = [gitlab_user.map]
}

resource "gitlab_project" "list" {
  for_each       = local.project_group_map
  name           = each.value.project_name
  path           = each.value.project_name
  # Gets group id given group name
  namespace_id   = gitlab_group.map[each.value.group_name].id
  #description    = local.project_group[count.index].group_description
  depends_on     = [gitlab_group_membership.map]
}
