VM_INTERNAL_NET_CONFIG_DIR="/home/exkernel/code/test-vm-management/net-config/vm-internal"
DHCP_CONFIG_DIR="$NET_CONFIG_DIR/dhcp"
DNS_CONFIG_DIR="$NET_CONFIG_DIR/dns"

function setup_dhcp {
	ssh root@10.1.1.2 "sudo apt install isc-dhcp-server -y"
	scp $DHCP_CONFIG_DIR/* root@10.1.1.2:/etc/dhcp/

	ssh root@10.1.1.2 "sudo systemctl restart isc-dhcp-server"
}

function setup_dns {
	ssh root@10.1.1.3 "sudo dnf install bind bind-utils -y; sleep 5s; sudo systemctl enable named; sudo systemctl start named"
	
	ssh root@10.1.1.3 "sudo sed 's/listen-on port 53 { 127.0.0.1; };/#listen-on port 53 { 127.0.0.1; };/' /etc/named.conf; sudo sed 's/listen-on-v6 port 53 { ::1; };/#listen-on-v6 port 53 { ::1; };/' /etc/named.conf; sudo sed 's/allow-query     { localhost; };/allow-query     { any; };/' /etc/named.conf"

	ssh root@10.1.1.3 "sudo rm -f /etc/named.rfc1912.zones"
	scp $DNS_CONFIG_DIR/named.rfc1912.zones root@10.1.1.3:/etc/
	scp $DNS_CONFIG_DIR/named/* root@10.1.1.3:/var/named/

	 ssh root@10.1.1.3 "sudo systemctl restart named"
}

setup_dhcp
setup_dns
