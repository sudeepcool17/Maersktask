## Q2 – SCENARIO (Problem statement and answer)


1.  What are different artifacts you need to create - name of the artifacts and its purpose
    - **main.tf** (desired state required at destination needs to be specified in this file)
    - **var.tf** (Variables to be referenced and which would change on demand)
    - **terraform.tfvars** (to store the values of the variables this file comes in handy when you want to deploy on different environments)
    - **secret.tfvars** (secret values)
2. List the tools you will to create and store the Terraform templates. You need a repository where you would save or maintain the tf.state files to track the state and
to figure out any drifts in the future
   - Artifactory : Nexus
   - Or Azure blob storage.
3. Explain the process and steps to create automated deployment pipeline.
    - Install plugin for Terraform and go to "Global Tool Configuration" and install the binaries there
    - Create a stage in the start called "provision” create a script to give path of the terraform script to provision the environment.

4. Create a sample Terraform template you will use to deploy Below services: (Vnet /2 Subnet /NSG
to open port 80 and 443 1 Window VM in each subnet 1 Storage account
The script it attached in the repo

5. Explain how will you access the password stored in Key Vault and use it as Admin Password in the
VM Terraform template
   - First need to setup key vault with the access policy which has been added to the script please check there
   - For the demonstration need to add variables for secrets and flag them as sensitive use separate "secret.tfvars” file as a best practise for this example
   - The secrets are referenced using "service principal” for a respective object id and tenant id for a subscription in prod environments.