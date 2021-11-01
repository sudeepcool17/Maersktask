# Pipeline Steps

### Q1 - SCENARIO (Problem statement & solution)

1) The build should trigger as soon as anyone in the dev team checks in code to master branch.
2) There will be test projects which will create and maintained in the solution along the Web and API. 
The trigger should build all the 3 projects - Web, API and test.
 The build should not be successful if any test fails.
3) The deployment of code and artifacts should be automated to Dev environment. 
4) Upon successful deployment to the Dev environment, deployment should be easily promoted to QA 
and Prod through automated process

---------
### Solution

1. Create a project on Azure Devops after your login
![Create Project](imgs/create-project.png)

2. Clone the git or version control remote repo to Azure repos
3. Create the pipeline after configuring the service connection in the Project settings
4. Create the Yaml pipeline and add the below step as we are using webapp for .netcore cli add this after the build steps

```yaml
- task: AzureWebApp@1
  inputs:
    azureSubscription: 'SP'
    appType: 'webAppLinux'
    appName: 'New-webapp'
    package: '$(System.DefaultWorkingDirectory)/**/*.zip'
```

5. Edit the project and make sure the below step is checked so that whenever a
Push happens to the branch the code gets triggered and published to the repository.
![Enable CI](imgs/enable-ci.png)

6. Now we have completed the build pipeline and now moving on to the release pipeline steps

7. Add the artifact and create the Dev stage and then link it to QA as below .The pre deployment step for QA will be if dev is triggered
![Release Pipeline](imgs/release-pipeline.png)

8. Create stagging slot before prod deployment stage and add the swapping slot to configure the blue green deploy for Prod
![Staging Pipeline](imgs/Staging.png)

9. Add the post deployment approval at each stage
![Post Deploy Approval](imgs/post-deploy-approval.png)

10. Add manual intervention step before the prod deploy process to enhance security
![Manual Approval](imgs/manual-approval.png)

