locals {
  input = yamldecode(file("secrets.yaml"))
}


locals {
  project_group = flatten([for grp_key, group in local.input.group: [for project in group.projects: { group_name=group.name, project_name=project, group_description=group.description} ]])
  
  #  Output ex:
  #   [
  #   {
  #     "group_name" = "group1"
  #     "project_name" = "project1"
  #   },
  #   {
  #     "group_name" = "group1"
  #     "project_name" = "project3"
  #   },
  # ]
}

locals {
  group_id = {for item in gitlab_group.list[*]: item.name => item.id }
  # Output ex:
  # {
  #   "group1" = "32"
  #   "group2" = "33"
  #   "group3" = "34"
  #   "group4" = "35"
  # }

  
}

locals {
  user_id = {for item in gitlab_user.list[*]: item.name => item.id }
  depends_on = [gitlab_user.list]
  # Output ex:
  # {
  #   "user1" = "4"
  #   "user2" = "5"
  # }
}

locals {
  user_group = flatten([for user in local.input.user: [for group in user.group: {group_name=group.name, user_name=user.username, access=group.access}]])
  # Output ex:
  # [
  #   {
  #     "access" = "guest"
  #     "group_name" = "group1"
  #     "user_name" = "user1"
  #   },
  #   {
  #     "access" = "guest"
  #     "group_name" = "group2"
  #     "user_name" = "user1"
  #   },
  #   {
  #     "access" = "group21"
  #     "group_name" = "group12"
  #     "user_name" = "user2"
  #   },
  # ]
}

