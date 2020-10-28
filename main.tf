resource "gitlab_group" "list" {
  count       = length(local.input.group)
  name        = local.input.group[count.index].name
  path        = local.input.group[count.index].name
  description = local.input.group[count.index].description
}

resource "gitlab_user" "list" {
  count            = length(local.input.user)
  name             = local.input.user[count.index].name
  username         = local.input.user[count.index].username
  email            = local.input.user[count.index].email
  is_admin         = local.input.user[count.index].is_admin
  password         = local.input.user[count.index].password
  depends_on       = [gitlab_group.list]
}

resource "gitlab_group_membership" "list" {
  count        = length(local.user_group)
  # Gets group id given group name
  group_id     = local.group_id[local.user_group[count.index].group_name]
  # Gets user id given user name
  user_id      = local.user_id[local.user_group[count.index].user_name]
  access_level = local.user_group[count.index].access
  depends_on       = [gitlab_user.list]
}


resource "gitlab_project" "list" {
  count          = length(local.project_group)
  name           = local.project_group[count.index].project_name
  path           = local.project_group[count.index].project_name
  # Gets group id given group name
  namespace_id   = local.group_id[local.project_group[count.index].group_name]
  #description    = local.project_group[count.index].group_description
  depends_on     = [gitlab_group_membership.list]
}

# resource "gitlab_project" "example" {
#   name           = "projectred1"
#   namespace_id   = 69
#   description    = "This is project red"
# }

