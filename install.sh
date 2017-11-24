cd /usr/local/
wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
tar xvf go1.8.linux-amd64.tar.gz
rm go1.8.linux-amd64.tar.gz
export GOPATH=/opt/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
cat <<-EOF>> /root/.bashrc
export GOPATH=/opt/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
EOF

go get -v -u github.com/FreifunkBremen/yanic
cd /etc
wget

mkdir -p /var/lib/yanic
touch /var/log/yanic.log
useradd yanic
mkdir -p /var/www/html/meshviewer/data/
chown yanic /var/log/yanic.log /var/lib/yanic /var/www/html/meshviewer /var/www/html/meshviewer/data
cp /opt/go/src/github.com/FreifunkBremen/yanic/contrib/init/linux-systemd/yanic.service /lib/systemd/system/
systemctl daemon-reload
systemctl enable yanic
systemctl start yanic
touch /etc/iptables.d/500-Allow-respondd
cat <<-EOF>> /etc/iptables.d/500-Allow-respondd
# Allow Service respondd
ip46tables -A wan-input -p udp -m udp --dport 1001    -j ACCEPT
ip46tables -A mesh-input -p udp -m udp --dport 1001    -j ACCEPT
ip46tables -A wan-input -p udp -m udp --dport 45123    -j ACCEPT
ip46tables -A mesh-input -p udp -m udp --dport 45123    -j ACCEPT
EOF

build-firewall

