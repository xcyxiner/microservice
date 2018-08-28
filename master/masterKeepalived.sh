docker run \
--cap-add=NET_ADMIN \
--net=host \
--restart=always \
--name=keepalived \
-d \
--env KEEPALIVED_VIRTUAL_IPS="#PYTHON2BASH:['VIPADDRESS']" \
--env KEEPALIVED_STATE="BACKUP" \
--env KEEPALIVED_INTERFACE="MASTERETH0NAME" \
--env KEEPALIVED_UNICAST_PEERS="#PYTHON2BASH:[MEMBERSPEERS]"  \
--detach registry.cn-hangzhou.aliyuncs.com/anoy/keepalived