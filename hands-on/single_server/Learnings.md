## Deploy a Single Web Server.:

	1. GCP Projects can be created using terraform using the following resource.: resource "google_project"
		a. But they only work when it is under an org - hence created the project manually
	2. Inorder to create free tier compute instance - the following resource is used.: resource "google_compute_instance"
		a. Inorder to create any resource in gcp project, the respective apis must be enabled. 
		b. To do this via terraform - resource "google_project_service" is used. 
			i. Limitation.: It is used to enable one service at a time, hence count or for loop to be used
			ii. Pre-requisties.: The user/service account running the terraform code must have `serviceusage admin list` enabled
				1) https://stackoverflow.com/questions/70807862/how-to-solve-error-when-reading-or-editing-project-service-foo-container-google
	3. Deletion of state file.:
		a. State file in itself must be deleted only when ur working on unimportant personal projects
	4. `tags` given in "google_compute_instance" can be viewed in `Network tags` in console
	5. Only when the "access_config" is given under the "network" section - the ephermal (public) IP address is set
	6. Keep the tags as below, so that the firewall settings for VM is enabled with the default tags
	tags = ["http-server","https-server"] 
	7. The metadata_startup_script value when kept in startup-script.sh script works properly - instead of directly keeping in the terraform script. Anyway directly keeping gave some errors.
	8. For debugging check the `Serial port0` logs and the vm instance does not have the libs pre installed. So they must be installed before starting anything.
	9. INFO.: While creating VM's by default some firewall rules will be enabled.

