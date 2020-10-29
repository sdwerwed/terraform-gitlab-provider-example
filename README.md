# Terraform Gitlab Provider Example
This is an extendedable terraform module for User, Group, and Project Management. The input file is a yml file called secrets.yml, in general, it should be encrypted and the key should be secured in a Vault, just for testing purposes I have it in plain text as it doesn't contain any real information. 

You can add new data to yml and the terraform module will create those resourses dynamically.

Using this module you can:

1. Create new users
2. Create new projects
3. Create new groups
4. Specify projects for groups
5. Specify users for groups
6. Modify the resourses
7. Destory Objects

For now it does not:
1. Auto syncronize and fix the state drift, manual interaction is needed
2. Auto import existing resources, manual interaction is needed 

File description:

`variables.tf` contain the input data from `secrets.yml` and it is flattening some nested objects.   
`output.tf` contains the output variables.  
`main.tf` contain the resources for managing users, groups, projects.  
`provider.tf` specifies the provider and version.  
`versions.tf` specifies the terraform version.  
`secrets.yaml` has the most important data like secrets and user/group/project information.

Import current gitlab state:

For adding the resource state of the existing users, projects, groups you will need it to do terraform import, and configure the yml file accordingly if you want to do changes on those resources. It can be automated using a script but it is not implemented here.  
You can import a project state using `terraform import gitlab_project.example <id>`.  
You can import a user to a terraform state using `terraform import gitlab_user.example <id>`.  
You can import a group state using `terraform import gitlab_group.example <id>` .

State drift:

If someone modifies the resources in GitLab that is tracked by terraform state, there will state drift, to fix this run `terraform refresh`, it will update the state file according to the physical infrastructure without changing the actual infrastructure.

Issues:

Gitlab provider is not used that much as Cloud Providers, it is expected to find some bugs. For example, sometimes the POST /api/v4/projects for creating trips it gets `Internal Server Error 500`, it is creating the project just the reponse is lost, so the terraform sends the request again to create the project and gets error `Bad Request 400 already exists`, I will need to report this. 


Conclusion:

Gitlab provider can be used for gitlab managment but the operator should be really careful, the operator might change some values and break the project as there are no contraints, also it requires time to create fully working modules, it will be more usefull as the manual operations takes much more time. 

Next steps:

1. Investigate more and report the issue that is happening sometimes while creating new gitlab_project resource, it is creating the resourse correctly but the state is not correct because of return code 400 with error max limit exceded name and path already exists, but there are not projects with the those names. This is hapenning sometimes and randomly, there might be a gitlab internal dependency.
2. Enrich the yml file, for adding more arguments
3. Automate the state  syncronization while new resources are created manually using `terraform import`
4. Save the changes to a file.
