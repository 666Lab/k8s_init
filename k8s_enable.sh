# 필요 서비스 활성화 (재부팅 후에도 자동으로 시작되도록 설정)
systemctl enable --now containerd
systemctl enable --now kubelet