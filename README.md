# Terraform Gitlab Provider Example
This is a part of code that can be extended for User, Group, and Project Management. The input file is a yml file called secrets.yml, in general, it should be encrypted and the key should be secured in a Vault just for testing purposes I have it in plain text as it doesn't contain any real information.

Using this module you can:

1. Create a new user
2. Create a project
3. Create a group
4. Specify namespace (group) for projects
5 .Assign users to groups (and to its projects)
6 .Modify their attributes 

File description:

variables.tf contain the input data from secrets.yml and it is flattening some nested objects. output.tf contains just some output variables main.tf contain the resources for managing users, groups, projects. provider.tf specifies the provider and version. secrets.yaml has the most important data like secrets and user/group/project information.

Import current gitlab state:

For adding the state of the existing users, projects, groups you will need it to do terraform import and configure the yml file accordingly. It can be automated using a script. You can import a project state using terraform import . You can import a user to a terraform state using terraform import . You can import a group state using terraform import .

Issues:

Gitlab provider is not used in Terraform that much as Cloud Providers, it is expected to find some bugs. For example, sometimes it is trying to recreate the resource that already exists and it fails with API error "already exists" in this case, there might be drift on the state, `terraform refresh` might fix it, it is updating the state file according to the physical infrastructure without changing the actual infrastructure.

Conclusion:

Gitlab provider can be used for gitlab managment but you should be really careful, you might change some values and break the project also it requires time to create fully working modules, I believe it depends on the size of the team.

Next steps:

1. Investigate more and report the issue that is happening sometimes in gitlab_project resource, it is creating correctly the resourse but the state is not correct because of return code 400 while it shouldn't, there is something wrong with API limits.
2. Enrich the yml file
3. Auto sync the state while new resources are created manually terraform import
4. Save the output to a file maybe (probably) using this way terraform plan -out output.tf and terraform apply output.tf
