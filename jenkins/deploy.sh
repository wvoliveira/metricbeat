#!/usr/bin/env bash
#
# Deploy check-mk-agent
#

SERVICE_ENV="$1"
SERVICE_NAME="$2"
SERVICE_IMAGE="$3"
IMAGE_URL="${SERVICE_IMAGE}:v${BUILD_NUMBER}"

# override
SERVICE_NAME="${SERVICE_NAME}-${SERVICE_ENV}"

# Export DOCKER_HOSTS_DEPLOY
. ./jenkins/vars.sh "$SERVICE_ENV"


deploy_service() {

  for host in $(echo "$DOCKER_HOSTS_DEPLOY"); do 
    export DOCKER_HOST="$host"

    echo
    echo "Docker host: ${DOCKER_HOST}"
    echo "Service name: ${SERVICE_NAME}"
    echo "Service image: ${IMAGE_URL}"
    echo "Build number: ${BUILD_NUMBER}"
    echo

    send_command

  done  
}

send_command() {

  code_service_exists=$(docker service inspect "$SERVICE_NAME" > /dev/null 2>&1; echo "$?")

  if [[ "$code_service_exists" == "1" ]]; then

    echo "Creating service ${SERVICE_NAME}.."
    docker service create --name "$SERVICE_NAME" \
    --mode global \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,ro \
    --mount type=bind,source=/sys/fs/cgroup,target=/hostfs/sys/fs/cgroup,ro \
    --mount type=bind,source=/proc,target=/hostfs/proc,ro \
    --mount type=bind,source=/,target=/hostfs,ro \
    --env KIBANA_HOST="${KIBANA_HOST}" \
    --env ELASTIC_HOST="${ELASTIC_HOST}" \
    --env SERVICE_ENV="${SERVICE_ENV}" \
    --hostname "{{.Node.Hostname}}" \
    --restart-condition "$RESTART_CONDITION" \
    --restart-max-attempts "$RESTART_MAX_ATTEMPTS" \
    --restart-window "$RESTART_WINDOW" \
    --update-failure-action rollback \
    "$IMAGE_URL"

  elif [[ "$code_service_exists" == "0" ]]; then

    echo "Updating service ${SERVICE_NAME}.."
    docker service update \
    --mount-add type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,ro \
    --mount-add type=bind,source=/sys/fs/cgroup,target=/hostfs/sys/fs/cgroup,ro \
    --mount-add type=bind,source=/proc,target=/hostfs/proc,ro \
    --mount-add type=bind,source=/,target=/hostfs,ro \
    --env-add KIBANA_HOST="${KIBANA_HOST}" \
    --env-add ELASTIC_HOST="${ELASTIC_HOST}" \
    --env-add SERVICE_ENV="${SERVICE_ENV}" \
    --hostname "{{.Node.Hostname}}" \
    --update-failure-action rollback \
    --update-parallelism "$UPDATE_PARALLELISM" \
    --update-delay "$UPDATE_DELAY" \
    --limit-memory "$LIMIT_MEMORY" \
    --image "$IMAGE_URL" \
    "$SERVICE_NAME"

  fi
}

main() {
  deploy_service
}

main
