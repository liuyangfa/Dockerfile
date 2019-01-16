#!/bin/bash

file=".flag"

supervisor()
{
	service supervisor start
	cat > /etc/supervisor/conf.d/platon.conf <<EOF
[program:platon]
command=platon --identity platon --datadir /opt/node/data --port 16789 --rpcport 6789 --rpcapi "db,eth,net,web3,admin,personal" --rpc --nodekey /opt/node/data/platon/nodekey --debug --verbosity 5 --rpcaddr 0.0.0.0  --nodiscover  --syncmode "full" --gcmode "archive"
numprocs=1
autostart=true
startsecs=5
startretries=3
autorestart=unexpected
exitcodes=0,2
stopsignal=TERM
stopwaitsecs=10
user=root
redirect_stderr=true
stdout_logfile=/tmp/node.log
stdout_logfile_maxbytes=100MB
stdout_logfile_backups=20
EOF
}

initial()
{
	WORKDIR="/opt/node"
	ip=$(env | grep PLATONIP | awk -F'=' '{print $NF}' | tr -d '\n')
	
	cd $WORKDIR && ethkey genkeypair > key.txt
	
	
	nodekey=$(grep PrivateKey key.txt | awk '{print $NF}' | tr -d '\n')
	publickey=$(grep PublicKey key.txt | awk '{print $NF}' | tr -d '\n')
	
	echo $nodekey > ./data/platon/nodekey
	
	sed -i "12,14d" platon.json
	
	sed -i "s/fb886b3da4cf875f7d85e820a9b39df2170fd1966ffa0ddbcd738027f6f8e0256204e4873a2569ef299b324da3d0ed1afebb160d8ff401c2f09e20fb699e4005/$publickey/" platon.json
	sed -i "s/@3.121.115.180/@$ip/" platon.json
		
	echo -e "123456\n123456" | platon --datadir ./data account new
	
	platon --datadir ./data init platon.json
	
	echo "success" > .flag
	supervisor
	supervisorctl update
}


startup()
{
	service supervisor start
}

main()
{
	cd /opt/node

	if [ -f $file ];then
		startup
	else
		initial
	fi
}

main
