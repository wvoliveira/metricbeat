#!/usr/bin/env bash
#
# Export VARS
#

SERVICE_ENV="$1"

# Another docker port on Jenkins
DOCKER_HOST_BUILD="<host for build>:4243"

# To deploy
if [[ -n "$SERVICE_ENV" ]]; then
  case "$SERVICE_ENV" in
    "testing") export \
      DOCKER_HOSTS_DEPLOY="<swarm-test-host>" \
      SERVICE_ENV="testing" ;;
    "staging") export \
      DOCKER_HOSTS_DEPLOY="<swarm-stag-host>" \
      SERVICE_ENV="staging" ;;
    "production") export \
      DOCKER_HOSTS_DEPLOY="<swarm-prod-dc01 swarm-prod-dc02>" \
      SERVICE_ENV="production" ;;
  esac
fi

# Metricbeat variables
KIBANA_HOST="<kibana-host>:80"
ELASTIC_HOST="<elastic-host>:9200"

# Docker create and update policies
RESTART_MAX_ATTEMPTS="5"
RESTART_WINDOW="1m"
RESTART_CONDITION="any"
UPDATE_PARALLELISM="5"
UPDATE_DELAY="1s"
LIMIT_MEMORY="100M"
