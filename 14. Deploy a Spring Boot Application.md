# Deploy a SpringBoot Application

**Step 1:**
Using the knowledge you gained from the earlier labs create a new project with name `spring-UserName`. **Remember** to substitute the `UserName` with your userid.

**Step 2:**
Create a new application using SpringBoot S2I Builder image. Here we will deploy sample code from a git repository [https://github.com/debianmaster/spring-sample-app](). Please take time to understand the code; it is pretty simple.

You may want to clone this into your git repository and deploy that, if you want to make changes and test.

**Note** that here we are using an S2I builder image from docker directly. This S2I builder image was created using this Dockerfile [https://github.com/codecentric/springboot-maven3-centos/blob/master/Dockerfile]()


```
$ oc new-app veermuchandi/spring-mvn-base~https://github.com/debianmaster/spring-sample-app --name=spring-sample
--> Found Docker image c3ddd9e (20 minutes old) from Docker Hub for "veermuchandi/spring-mvn-base"

    Spring Boot Maven 3 
    ------------------- 
    Platform for building and running Spring Boot applications

    Tags: builder, java, java8, maven, maven3, springboot

    * An image stream will be created as "spring-mvn-base:latest" that will track the source image
    * A source build using source code from https://github.com/debianmaster/spring-sample-app will be created
      * The resulting image will be pushed to image stream "spring-sample:latest"
      * Every time "spring-mvn-base:latest" changes a new build will be triggered
    * This image will be deployed in deployment config "spring-sample"
    * Port 8080/tcp will be load balanced by service "spring-sample"
      * Other containers can access this service through the hostname "spring-sample"

--> Creating resources with label app=spring-sample ...
    imagestream "spring-mvn-base" created
    imagestream "spring-sample" created
    buildconfig "spring-sample" created
    deploymentconfig "spring-sample" created
    service "spring-sample" created
--> Success
    Build scheduled, use 'oc logs -f bc/spring-sample' to track its progress.
    Run 'oc status' to view your app.
```

Note the above command creates imagestreams for the spring base image and your applciation. It creates a build configuration and deployment configuration for your application and a service front-ending your spring application pods.

Expose the service to create a route.

```
oc expose service spring-sample
```

Check the route

```
$ oc get route
NAME            HOST/PORT                                        PATH      SERVICES        PORT       TERMINATION
spring-sample   spring-sample-spring-UserName.apps.devday.ocpcloud.com             spring-sample   8080-tcp
```

Wait for your application to be built and deployed. Using the knowlege you gained from the previous labs, check your build logs by running `oc logs -f <build pod name>`

**Step 3**

Test your application by using the hostname assigned in the route.

Congratulations!! You are now running a SpringBoot application on OpenShift.







