#!/bin/bash
sed -i 's/PBS_START_MOM=0/PBS_START_MOM=1/g' /etc/pbs.conf
sed -i "s/^PBS_SERVER.*/PBS_SERVER=$(hostname)/g" /etc/pbs.conf
/etc/init.d/pbs restart
