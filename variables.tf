locals {
  input = yamldecode(file("secrets.yaml"))
}


locals {
  project_group = flatten([for grp_key, group in local.input.group: [for project in group.projects: { group_name=group.name, project_name=project, group_description=group.description} ]])
  #  Output ex:
  #   [
  #     { 
  #       "group_description" = "This is group1"
  #       "group_name" = "group1"
  #       "project_name" = "project1"
  #     },
  #     {
  #       "group_description" = "This is group1"
  #       "group_name" = "group1"
  #       "project_name" = "project3"
  #     },
  #   ]

  project_group_map = {for item in local.project_group: "${item.project_name}.${item.group_name}" => item}
  # Output ex:
  # {
  #   "projectblue1.blue" = {
  #     "group_description" = "This is project blue"
  #     "group_name" = "blue"
  #     "project_name" = "projectblue1"
  #   }
  #   "projectblue2.blue" = {
  #     "group_description" = "This is project blue"
  #     "group_name" = "blue"
  #     "project_name" = "projectblue2"
  #   }
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

  user_group_map = {for item in toset(local.user_group): "${item.user_name}.${item.group_name}" => item}
  # Output ex:
  # {
  #   "user1.blue" = {
  #     "access" = "guest"
  #     "group_name" = "blue"
  #     "user_name" = "user1"
  #   }
  #   "user1.green" = {
  #     "access" = "guest"
  #     "group_name" = "green"
  #     "user_name" = "user1"
  #   }
  # }
}

locals {
  users_map = {for item in local.input.user: item.name => item}
  # Output ex:
  # {
  #   "user1" = {
  #     "email" = "user1@gmail.com"
  #     "group" = [
  #       {
  #         "access" = "guest"
  #         "name" = "red"
  #       },
  #       {
  #         "access" = "guest"
  #         "name" = "blue"
  #       },
  #       {
  #         "access" = "guest"
  #         "name" = "green"
  #       },
  #     ]
  #     "is_admin" = false
  #     "name" = "user1"
  #     "password" = "12345f!sddsd"
  #     "username" = "user1"
  #   }
  # }

}


locals  {
  group_map = {for item in local.input.group: item.name => item}
  # Output ex:
  # {
  #   "blue" = {
  #     "auto_devops_enabled" = false
  #     "description" = "This is project blue"
  #     "name" = "blue"
  #     "projects" = [
  #       "projectblue1",
  #       "projectblue2",
  #       "projectblue3",
  #     ]
  #     "two_factor_grace_period" = 48
  #   }
  # }
}