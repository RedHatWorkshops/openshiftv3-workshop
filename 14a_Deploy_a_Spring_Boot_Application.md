## Deploy a SpringBoot Application

In this exercise we will deploy a SpringBoot application using a custom source to image builder image.

**Step 1:**
Using the knowledge you gained from the earlier labs create a new project with name `spring-UserName`.
**Remember** to substitute the `UserName` with your userid.

**Step 2:**
Create a new application using SpringBoot S2I Builder image. Here we will deploy sample code from a git repository [https://github.com/RedHatWorkshops/spring-sample-app](https://github.com/RedHatWorkshops/spring-sample-app). Please take time to understand the code; it is pretty simple.

You may want to clone this into your git repository and deploy that, if you want to make changes and test.

**Note:** We are using an S2I builder image from access.redhat.com/containers. This S2I builder image is https://access.redhat.com/containers/?tab=images&platform=openshift#/registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift


1. login Web UI via browswer to https://<master>:8443
2. create a project with you username
3. click Add to project
4. search for "redhat-openjdk18-openshift" 
5. Click select from the redhat-openjdk18-openshift Version
6. Name: bootapp
7. Git Regposity URL: https://github.com/RedHatWorkshops/spring-sample-app.git
8. Click Show advanced link 
9. Go to 'Build Configuration' section, add following Environment Variable:
   MAVEN_MIRROR_URL
   http://nexus.nexus.svc.cluster.local:8081/repository/maven-public
10. Go to the end and click create.
11. Click Builds/builds from left navigation
12. Click bootapp
13. Click View Log to view the build log
11. Click on 'Overview' from the left navigation
12. Click create route and Click create. Route will be created
13. Test your spring boot application


**Step 3**

Test your application by using the hostname assigned in the route.

Congratulations!! You are now running a SpringBoot application on OpenShift.
