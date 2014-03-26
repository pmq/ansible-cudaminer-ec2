#! /bin/sh

SSH_IDENTITY=~/.ssh/aws-mining.pem
AWS_USER=ec2-user
# VERBOSE=-vv
VERBOSE=-vvvv

ANSIBLE_GROUP=ec2
ANSIBLE_INVENTORY=hosts
# ANSIBLE_INVENTORY=ec2.py

usage() {
    echo "Usage: $0 [ping | mine]"
    exit 0
}

ping() {
    ansible ${ANSIBLE_GROUP} -i ${ANSIBLE_INVENTORY} -u ${AWS_USER} \
	 --private-key=${SSH_IDENTITY} ${VERBOSE} -m ping
}

run() {
    ansible-playbook -i ${ANSIBLE_INVENTORY} -u ${AWS_USER} \
	 --private-key=${SSH_IDENTITY} ${VERBOSE} to-the-moon.yml
}

if [ $# -lt 1 ]
then
    usage
fi

case "$1" in
    ping) ping
	;;
    run) run
	;;
    *) usage
	;;
esac
