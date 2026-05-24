apt install containerd -y
mkdir -p /etc/containerd

containerd config default | tee /etc/containerd/config.toml > /dev/null
printf "Configuring containerd for Kubernetes...\n"
sed -i 's/disabled_plugins = \["cri"\]/disabled_plugins = []/' /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd