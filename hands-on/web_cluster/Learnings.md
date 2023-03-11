## Deploying a cluster of web servers.:

	1. Differences.:
		The google_compute_from_instance_template resource and google_compute_instance_template resource in GCP Terraform have different purposes:
		• google_compute_instance_template: This resource is used to create an instance template in GCP, which is a resource that you can use to define a machine configuration for a group of VM instances. The google_compute_instance_template resource defines the properties of the instance template, such as the machine type, boot disk image, network settings, and other configuration options.
		• google_compute_from_instance_template: This resource is used to create an instance group manager in GCP that is based on an instance template. An instance group manager is a resource that manages a group of VM instances that are created from an instance template. The google_compute_from_instance_template resource references an existing google_compute_instance_template resource and uses it to create and manage VM instances.
		In summary, google_compute_instance_template is used to create an instance template, while google_compute_from_instance_template is used to create an instance group manager that is based on an existing instance template.
		
	2. To remove a particular resource created by Terraform from state file as well as remote, you can use the terraform destroy command followed by the resource ID. terraform destroy -target=my_resource
	3. /bin/bash^M: bad interpreter: No such file or directory even while writing it in .sh file ---> Error Resolution.: Various ways are present if using a linux desktop. For windows execute this command in powershell.: (Get-Content -Path /path/to/file.sh -Raw) -replace "`r`n", "`n" | Set-Content -Path /path/to/file.sh
		a. Reason for error.: Due to line endings. The above command converts CLRF to LRF line endings
	4. Updating  of VM Instances when using template.:
		a. When a template is updated, the group manager alone is updated to use the new template - this means that the existing VM's created earlier by prev template is not updated and the new instances which will be created hence forth will have the new changes.
		b. Inorder to update the existing instances, rolling updates or various other deployment strategies can be followed - https://github.com/hashicorp/terraform/issues/3875
		c. And inorder to update the existing VM's , from the beginning (when creating the group manager configuration) The update_policy block has to be included. Otherwise step.a keeps happening.
