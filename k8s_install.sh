# https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

#root 권한으로 실행되지 않으면 빠꾸먹이기
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

#버전
KUBE_VERSION="v1.36"

# 스왑 영구 비활성화
systemctl disable --now swap.target
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab

apt update
apt install -y apt-transport-https ca-certificates curl gpg

# 공개키 다운로드 및 저장
mkdir -p /etc/apt/keyrings
curl -fsSL "https://pkgs.k8s.io/core:/stable:/${KUBE_VERSION}/deb/Release.key" \ | gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# 레포지토리 추가
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBE_VERSION/deb/ /" \ | tee /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubectl kubelet kubeadm

# 버전 홀드
apt-mark hold kubectl kubelet kubeadm

# (옵션) 홀드 해제 후 업데이트
# apt-mark unhold kubelet kubeadm kubectl
# apt update
# apt upgrade -y kubelet kubeadm kubectl
