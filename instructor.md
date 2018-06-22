### Installation

use the following command to install the workshop:

```
oc new-project workshop

oc new-app samueltauil/workshopper \
  -e CONTENT_URL_PREFIX="https://raw.githubusercontent.com/gnunn1/openshiftv3-workshop/3.7" \
  -e WORKSHOPS_URLS="https://raw.githubusercontent.com/gnunn1/openshiftv3-workshop/3.7/_module_groups.yml" \
  --name=workshop

oc expose svc workshop
```
