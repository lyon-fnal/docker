# Monitoring
help-monitoring:
	@echo '  make monitoring         -- Turn on monitoring'
	@echo '  make monitoring-stop    -- Turn off monitoring'

monitoring-start:
	docker run \
		-d \
		-p 5022:22 \
		-p 8088:8088 \
		-p 8443:8443 \
		-p 8081:8081 \
		-p 8084:8084 \
		-p 8082:8082/udp \
		-e AXIBASE_USER_PASSWORD=abcdefgh \
		-e ATSD_USER_NAME=user \
		-e ATSD_USER_PASSWORD=abcdefgh \
		-h atsd \
		--name=atsd \
		axibase/atsd:latest

	docker run \
	  --volume=/:/rootfs:ro \
	  --volume=/var/run:/var/run:rw \
	  --volume=/sys:/sys:ro \
	  --volume=/var/lib/docker/:/var/lib/docker:ro \
	  --volume=$(CURDIR):/root \
	  --publish=9090:8080 \
	  --detach=true \
	  --name=cadvisor \
	  --link atsd:atsd \
	  axibase/cadvisor:latest \
	  --storage_driver=atsd \
	  --storage_driver_user=user \
	  --storage_driver_password=abcdefgh \
	  --storage_driver_atsd_config_path="/root/cadvisor.toml"

	@echo Check logs with docker logs -f atsd and wait for start \(takes awhile\)
	@echo Look at instananeous monitoring from CAdivsor on port 9090
	@echo Look at historical monitoring on port 8088

monitoring-stop:
	-docker stop atsd cadvisor
	-docker rm atsd cadvisor
