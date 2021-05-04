build:
	docker build -t bpfenv .  

run:
	docker run -ti \
		--privileged \
		--pid host \
		--net host \
		--volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
		--volume /sys/kernel/debug:/sys/kernel/debug:ro \
		--volume /sys/fs/bpf:/sys/fs/bpf:ro \
		--volume /lib/modules:/lib/modules \
		bpfenv bash

.PHONY: build run
