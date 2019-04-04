FROM docker.elastic.co/beats/metricbeat-oss:6.6.1

LABEL name="Metricbeat" \
      maintainer="Devops Team <devops@catho.com>" \
      app_repository="http://gitlab.devel/panda/microservices/metricbeat"

USER root

COPY conf/metricbeat.yml /usr/share/metricbeat/metricbeat.yml
COPY conf/modules.d /usr/share/metricbeat/modules.d

RUN chmod -R go-w /usr/share/metricbeat/

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s --retries=3 \
    CMD ps aux | grep '[m]etricbeat' || exit 1
