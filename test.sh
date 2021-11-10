#!/bin/bash

INTERNAL=$1
OUTDIR="output/${INTERNAL}"

echo "running with INTERNAL=${INTERNAL}"
echo "output in ${OUTDIR}"
mkdir $OUTDIR

for i in 1 2 ; do docker-compose -f internal-${INTERNAL}.yml -p  internal-${INTERNAL}${i} up -d; done

for i in 1 2 ; do docker exec -it internal-${INTERNAL}${i}_c1_1 /bin/sh -c 'dig c1 +short && for ip in $(dig c1 +short); do dig -x $ip +short; done'; done

#debug output
docker ps -a > ${OUTDIR}/docker-ps
docker network ls > ${OUTDIR}/docker-net-ls
for i in 1 2 ; do docker inspect internal-${INTERNAL}${i}_c1_1 > ${OUTDIR}/docker-inspect
for i in 1 2 ; do docker network inspect internal-${INTERNAL}${i}_default; done > ${OUTDIR}/docker-net-inspect ; done
sudo iptables -nvL FORWARD > ${OUTDIR}/iptables


for i in 1 2 ; do docker-compose -f internal-${INTERNAL}.yml -p  internal-${INTERNAL}${i} down --remove-orphans ; done


