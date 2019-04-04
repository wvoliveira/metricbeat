# Metricbeat

Collect metrics from docker swarm  
Run as global service in all environments

## Tested

- Docker 18.03.1-ce|18.09.3

## Run

Run:

```bash
docker-compose -f docker-compose.yml up --build
```

OR just check conf file

```bash
docker run --rm -v "$(pwd)/conf/metricbeat.yml:/usr/share/metricbeat/metricbeat.yml" docker.elastic.co/beats/metricbeat-oss:6.6.1 metricbeat test config # or modules
```
