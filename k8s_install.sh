#root 권한으로 실행되지 않으면 빠꾸먹이기
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# 스왑 영구 비활성화
systemctl disable --now swap.target

apt update
apt install -y apt-transport-https ca-certificates curl
apt install -y apt-transport-https

# 공개키 다운로드 및 저장
curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# 레포지토리 추가
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt update
apt install -y kubectl kubelet kubeadm

# 버전 홀드
apt-mark hold kubectl kubelet kubeadm

# (옵션) 홀드 해제 후 업데이트
# apt-mark unhold kubelet kubeadm kubectl
# apt update
# apt upgrade -y kubelet kubeadm kubectl