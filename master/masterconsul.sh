docker run -d -p 8300:8300 -p 8301:8301 -p 8301:8301/udp -p 8302:8302 -p 8302:8302/udp -p 8400:8400 -p 8500:8500 -p 8600:53 -p 8600:53/udp -h MASTERHOSTNAME --restart=always --name=consul progrium/consul -server -bootstrap-expect 3 -ui-dir=/ui -advertise MASTERIP -client 0.0.0.0
