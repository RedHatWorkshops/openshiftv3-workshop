# Provisioning Instructions

To provision the workshop on OCP just execute the following:

```
oc new-app samueltauil/workshopper \
-e CONTENT_URL_PREFIX="https://raw.githubusercontent.com/RedHatWorkshops/openshiftv3-workshop/asciidoc" \
-e WORKSHOPS_URLS="https://raw.githubusercontent.com/RedHatWorkshops/openshiftv3-workshop/asciidoc/_module_groups.yml"
```
