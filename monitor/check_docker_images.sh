#!/bin/bash

packages=$(/usr/bin/docker image ls --all | /usr/bin/tail -n +2 | /usr/bin/awk '{ print $1 }')

for package in ${packages[*]}; do
  if [ "${package}" == "<none>" ]; then
    continue
  fi
  docker_hub=$(~/tixati/monitor/digest-v2.sh ${package}:latest \
             | grep "etag" | awk '{ print $2 }' | tr -d \" | tr -d '\r')
  local_image=$(/usr/bin/docker image inspect ${package} --format '{{json .RepoDigests}}' \
             | jq . | grep "@" | awk -F@ '{print $2}' | tr -d \")
  if [ "${docker_hub}" != "${local_image}" ]; then
    email="${email}
<pre>
Local Docker Image ${package} needs to be upgraded:
 docker hub: ${docker_hub}
 local img : ${local_image}
 
</pre>" 
  fi
done
if [ "${email}" ]; then
  echo "${email}" | /usr/bin/mutt -e "set content_type=text/html" -s "Docker Image(s) Needs Updating" matt@selick.com 2>&1
fi
