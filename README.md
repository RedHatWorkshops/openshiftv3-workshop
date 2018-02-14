# OpenShift Workshop Labs
To provision the workshop on OCP just execute the following:

```
oc new-app samueltauil/workshopper -e CONTENT_URL_PREFIX="https://raw.githubusercontent.com/samueltauil/openshiftv3-workshop/master" -e WORKSHOPS_URLS="https://raw.githubusercontent.com/samueltauil/openshiftv3-workshop/master/_module_groups.yml"
```

## Lab Exercises Table of Contents
* Lab 0. [Setting up client tools](0-setting-up-client-tools.adoc)
* Lab 1. [22-Containerize-Outage-App](22-Containerize-Outage-App)
* Lab 2. [Creating an application from an existing Docker Image using CLI](1-create-app-from-docker-image.adoc)
* Lab 3. [Create an application using Docker Build Strategy using CLI](2-create-app-using-docker-build.adoc)
* Lab 4. [Using Web Console](3-using-web-console.adoc)
* Lab 5. [Creating an application using JBoss EAP builder image](4-create-app-using-jboss-builder-image.adoc)
* Lab 6. [Creating an application with frontend and backend database using templates](5-using-templates.adoc)
* Lab 7. [Scale Up Scale Down and Idle the application instances](6-scaling-app-instances.adoc)
* Lab 8. [Binary deployment of a war file](7-binary-deployment-war-file.adoc)
* Lab 9. [Using SSL In your Application](8-using-ssl-app.adoc)
* Lab 10. [Blue-Green Deployments](9-bluegreen-deployments.adoc)
* Lab 11. [SCM - Web Hooks](10-webhooks.adoc)
* Lab 12. [Rollback Applications](11-rollback-applications.adoc)
* Lab 13. [Code Promotion Across Environments](12-code-promotion-across-envs.adoc)
* Lab 14. [Deploy Spring Boot Application](14-deploy-springboot-app.adoc)
* Lab 15. [Adding Spring Boot to Project Catalog](15-adding-springboot-sti-to-catalog.adoc)
* Lab 16. [Adding Database to your SpringBoot App](16-adding-database-to-springboot-app.adoc)
* Lab 17. [Dynamic Configuration updates using ConfigMap](17-dynamic-config-updates-using-configmaps.adoc)
* Lab 18. [Changing code on the fly](18-changing-code-onthefly.adoc)
