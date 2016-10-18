## Create an App using Docker build

In this exercise we will learn how to create an application from a Dockerfile. OpenShift takes Dockerfile as an input and generates your application docker image for you.

**Step 1: Create a project or use an existing project**

If you want to, you can create a new project based on what you have learned in the previous lab. Since we already have a project we will use it. Run the following command to make sure.
**Remember** to substitute UserName with your username.

```
$ oc project mycliproject-UserName
```

**Step 2: Create an application that uses docker file**

This time we will use a project that has a Dockerfile in a source code repository. We will use a simple project on github (https://github.com/VeerMuchandi/time). "rhel" folder from this github project is built starting with rhel7 as the base image which is described in Dockerfile.  Look at the Dockerfile for this project. It starts off with `registry.access.redhat.com/rhel7` image. It copies the source code which is a simple `init.sh` file and exposes port `8080`. Look at the `init.sh` that just displays the current datetime. There is also a PHP version of the same project available in the php folder if you like to use that. The php version does exactly the same it has a `time.php` file that displays the time.

**Docker Build**: When OpenShift finds a Dockerfile in the source, it uses this Dockerfile as the basis to create a docker image for your application. This strategy is called "Docker Build" strategy on OpenShift. We'll see more about it when we look at the build configuration a couple of steps down the line. Once OpenShift builds the application's docker image, it stores that in a local docker registry. Later it uses this image to deploy an application that runs in a pod.

Now let's create an application using this approach. We will run `oc new-app` command by supplying the git uri as the parameter.

```
$ oc new-app https://github.com/VeerMuchandi/time --context-dir=rhel

--> Found Docker image 1d309a6 (6 weeks old) from registry.access.redhat.com for "registry.access.redhat.com/rhel7"

    * An image stream will be created as "rhel7:latest" that will track the source image
    * A Docker build using source code from https://github.com/VeerMuchandi/time will be created
      * The resulting image will be pushed to image stream "time:latest"
      * Every time "rhel7:latest" changes a new build will be triggered
    * This image will be deployed in deployment config "time"
    * Port 8080 will be load balanced by service "time"
      * Other containers can access this service through the hostname "time"
    * WARNING: Image "registry.access.redhat.com/rhel7" runs as the 'root' user which may not be permitted by your cluster administrator

--> Creating resources with label app=time ...
    imagestream "rhel7" created
    imagestream "time" created
    buildconfig "time" created
    deploymentconfig "time" created
    service "time" created
--> Success
    Build scheduled, use 'oc logs -f bc/time' to track its progress.
    Run 'oc status' to view your app.
```

You'll notice that OpenShift created a few things at this point. You will find a buildconfig, deploymentconfig, service and imagestreams in the above list. The application is not running yet. It needs to be built and deployed. Within a minute or so, you will see that OpenShift starts the build.

**Step 3: Build**

In the meanwhile lets have a look at the buildconfig by running the command shown below.


```
$ oc get bc time -o json

{
    "kind": "BuildConfig",
    "apiVersion": "v1",
    "metadata": {
        "name": "time",
        "namespace": "mycliproject-user10",
        "selfLink": "/oapi/v1/namespaces/mycliproject-admin/buildconfigs/time",
        "uid": "ac4beccd-9569-11e6-ad4c-000d3af733e4",
        "resourceVersion": "134692",
        "creationTimestamp": "2016-10-18T19:32:57Z",
        "labels": {
            "app": "time"
        },
        "annotations": {
            "openshift.io/generated-by": "OpenShiftNewApp"
        }
    },
    "spec": {
        "triggers": [
            {
                "type": "GitHub",
                "github": {
                    "secret": "1pOQJ1G5tr6M70CQ5779"
                }
            },
            {
                "type": "Generic",
                "generic": {
                    "secret": "Bge9C-De7rm9PPDG_EQR"
                }
            },
            {
                "type": "ConfigChange"
            },
            {
                "type": "ImageChange",
                "imageChange": {
                    "lastTriggeredImageID": "registry.access.redhat.com/rhel7@sha256:eac2421be7a6844a5c83b8f394d1f5f121b18fa4e455c5f09be940e0384a1d97"
                }
            }
        ],
        "runPolicy": "Serial",
        "source": {
            "type": "Git",
            "git": {
                "uri": "https://github.com/VeerMuchandi/time"
            },
            "contextDir": "rhel"
        },
        "strategy": {
            "type": "Docker",
            "dockerStrategy": {
                "from": {
                    "kind": "ImageStreamTag",
                    "name": "rhel7:latest"
                }
            }
        },
        "output": {
            "to": {
                "kind": "ImageStreamTag",
                "name": "time:latest"
            }
        },
        "resources": {},
        "postCommit": {}
    },
    "status": {
        "lastVersion": 1
    }
}
```

Note the name of the buildconfig in metadata is set to "time", the git uri pointing to the value you gave while creating the application. Also note the Strategy.type set to "Docker". This indicates that the build will use the instructions in this Dockerfile to do the docker build.

Build starts in a minute or so. You can view the list of builds using `oc get builds` command. You can also start the build using `oc start-build time` where "time" is the name we noticed in the buildconfig.

```
$ oc get builds
NAME      TYPE      STATUS    POD
time-1    Docker    Running   time-1-build
```

Note the name of the build that is running i.e. time-1. We will use that name to look at the build logs. Run the command as shown below to look at the build logs. This will run for a few mins. At the end you will notice that the docker image is successfully created and it will start pushing this to OpenShift's internal docker registry.


```
$ oc logs build/time-1

....
....
....
....
Successfully built 99563b872361
I0701 01:00:01.954898       1 cfg.go:46] PUSH_DOCKERCFG_PATH=/var/run/secrets/openshift.io/push/.dockercfg
I0701 01:00:01.955401       1 cfg.go:64] Using serviceaccount user for Docker authentication
I0701 01:00:01.955426       1 docker.go:84] Using Docker authentication provided
I0701 01:00:01.955441       1 docker.go:87] Pushing 172.30.246.7:5000/mycliproject/time image ...
I0701 01:05:24.258995       1 docker.go:91] Successfully pushed 172.30.246.7:5000/mycliproject/time

```
In the above log note how the image is pushed to the local docker registry. The registry is running at `172.30.246.7` at port `5000`.

***Step 4: Deployment***

Once the image is pushed to the docker registry, OpenShift will trigger a deploy process. Let us also quickly look at the deployment configuration by running the following command. Note dc represents deploymentconfig.

```
$ oc get dc -o json

{
    "kind": "List",
    "apiVersion": "v1",
    "metadata": {},
    "items": [
        {
            "kind": "DeploymentConfig",
            "apiVersion": "v1",
            "metadata": {
                "name": "time",
                "namespace": "mycliproject",
                "selfLink": "/osapi/v1beta3/namespaces/mycliproject/deploymentconfigs/time",
                "uid": "85a3d5c0-1fad-11e5-a792-fa163e91b409",
                "resourceVersion": "12684",
                "creationTimestamp": "2015-07-01T04:56:23Z"
            },
            "spec": {
                "strategy": {
                    "type": "Recreate",
                    "resources": {}
                },
                "triggers": [
                    {
                        "type": "ConfigChange"
                    },
                    {
                        "type": "ImageChange",
                        "imageChangeParams": {
                            "automatic": true,
                            "containerNames": [
                                "time"
                            ],
                            "from": {
                                "kind": "ImageStreamTag",
                                "name": "time:latest"
                            },
                            "lastTriggeredImage": "172.30.246.7:5000/mycliproject/time@sha256:1251dbf51a699928359046c0d5a98601fb2883f34c24a6ca80492c5a047942f5"
                        }
                    }
                ],
                "replicas": 1,
                "selector": {
                    "deploymentconfig": "time"
                },
                "template": {
                    "metadata": {
                        "creationTimestamp": null,
                        "labels": {
                            "deploymentconfig": "time"
                        }
                    },
                    "spec": {
                        "containers": [
                            {
                                "name": "time",
                                "image": "172.30.246.7:5000/mycliproject/time@sha256:1251dbf51a699928359046c0d5a98601fb2883f34c24a6ca80492c5a047942f5",
                                "ports": [
                                    {
                                        "name": "time-tcp-80",
                                        "containerPort": 80,
                                        "protocol": "TCP"
                                    }
                                ],
                                "resources": {},
                                "terminationMessagePath": "/dev/termination-log",
                                "imagePullPolicy": "Always",
                                "securityContext": {
                                    "capabilities": {},
                                    "privileged": false
                                }
                            }
                        ],
                        "restartPolicy": "Always",
                        "dnsPolicy": "ClusterFirst"
                    }
                }
            },
            "status": {
                "latestVersion": 2,
                "details": {
                    "causes": [
                        {
                            "type": "ImageChange",
                            "imageTrigger": {
                                "from": {
                                    "kind": "DockerImage",
                                    "name": "172.30.246.7:5000/mycliproject/time:latest"
                                }
                            }
                        }
                    ]
                }
            }
        }
    ]
}
```

Note where the image is picked from. It shows that the deployment picks the image from the local registry (same ip address and port as in buildconfig) and the image tag is same as what we built earlier. This means the deployment step deploys the application image what was built earlier during the build step.

If you get the list of pods, you'll notice that the application gets deployed quickly and starts running in its own pod.

```
$ oc get pods

NAME           READY     STATUS      RESTARTS   AGE
time-1-build   0/1       Completed   0          2h
time-1-rqa7c   1/1       Running     0          2h
```

**Step 5: Adding route**

This step is very much the same as what we did in the previous exercise. We will check the service and add a route to expose that service.

```
$ oc get services

NAME      CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
time      172.30.xx.82   <none>        8080/TCP   2h
```

Here we expose the service as a route.

```
$ oc expose service time

NAME      HOST/PORT   PATH      SERVICE   LABELS     TLS TERMINATION
time                            time      app=time
```

And then we check the route exposed.

```
$ oc get routes

NAME      HOST/PORT                                                          PATH      SERVICES   PORT       TERMINATION
time      time-mycliproject-UserName.apps.osecloud.com                       time       8080-tcp   
```

**Note:** Unlike in the previous lab, this time we did not use --hostname parameter while exposing the service to create a route. OpenShift automatically assigned the project name extension to the route name.

**Step 6: Run the application**

Now run the application by using the route you provided in the previous step. You can use either curl or your browser. The application displays time. **If you don't provide time.php extension, it displays apache's default index page.**

```
$ curl time-mycliproject-UserName.apps.osecloud.com
Wednesday 1st of July 2015 01:12:20 AM
```

Congratulations!! In this exercise you have learnt how to create, build and deploy an application using OpenShift's "Docker Build strategy".
