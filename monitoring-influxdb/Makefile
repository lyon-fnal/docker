# Monitoring
help-monitoring:
	@echo '  make monitoring         -- Turn on monitoring'
	@echo '  make monitoring-stop    -- Turn off monitoring'

monitoring-start:
	# InfluxDB stores the monitoring data
	docker run -d -p 8083:8083 -p 8086:8086 --expose 8090 --expose 8099 \
						 -e PRE_CREATE_DB=cadvisor \
						 --name influxsrv tutum/influxdb

	# Cadvisor collects the monitoring data
	docker run \
		--volume=/:/rootfs:ro \
		--volume=/var/run:/var/run:rw \
		--volume=/sys:/sys:ro \
		--volume=/var/lib/docker/:/var/lib/docker:ro \
		--publish=9090:8080 \
		--link=influxsrv:influxsrv  \
		--detach=true \
		--name=cadvisor \
		google/cadvisor \
		-storage_driver=influxdb \
		-storage_driver_db=cadvisor \
		-storage_driver_host=influxsrv:8086

	docker run -d -v /var/lib/grafana -v /Users:/Users --name grafana-storage busybox:latest cp $(PWD)/grafana/grafana.db /var/lib/grafana

	# Grafana displays the monitoring data
	docker run -d \
		-e HTTP_USER=admin \
		-e HTTP_PASS=admin \
		-e INFLUXDB_HOST=localhost \
		-e INFLUXDB_PORT=8086 \
		-e INFLUXDB_NAME=cadvisor \
		-e INFLUXDB_USER=root \
		-e INFLUXDB_PASS=root \
		--link=influxsrv:influxsrv  \
		--name=grafana \
		--volumes-from grafana-storage \
		-p 3000:3000 \
		grafana/grafana

	@echo Look at instananeous monitoring from CAdivsor on port 9090
	@echo Look at historical monitoring on port 3000

monitoring-stop:
	-docker stop influxsrv cadvisor grafana grafana-storage
	-docker rm influxsrv cadvisor grafana grafana-storage

monitoring-grafana-save-config:
	docker exec grafana cp /var/lib/grafana/grafana.db $(PWD)/grafana/grafana.db
