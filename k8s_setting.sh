# 스왑 영구 비활성화
swapoff -a
sed -i.bak '/\sswap\s/s/^/#/' /etc/fstab
systemctl disable --now swap.target

# 주요 모듈 로드
printf "===== Loading kernel modules =====\n"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

# 컨테이너 런타임 설정
printf "===== Setting sysctl parameters for Kubernetes =====\n"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

printf "===== Applying sysctl parameters =====\n"
sysctl --system

# 방화벽 조정
