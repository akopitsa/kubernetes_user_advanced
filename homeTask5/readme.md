### Install
. /etc/os-release
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${ID^}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${ID^}_${VERSION_ID}/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo apt-get update -qq
sudo apt-get -qq -y install buildah

or

sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:projectatomic/ppa
sudo apt install buildah
--------------------------
## Commands
*buildah --help*

**get image**

*buildah from ubuntu*

**list images**

*buildah images*

*buildah containers*

**remove images**

*buildah rm --all*

*buildah run ubuntu-working-container apt update*

*buildah run ubuntu-working-container apt install apache2*

*buildah copy ubuntu-working-container index.html /var/www/html/index.html*

*buildah config --entrypoint "/usr/sbin/apache2ctl -DFOREGROUND" ubuntu-working-container*

*buildah commit ubuntu-working-container  linux-andrey-test*

*buildah commit ubuntu-working-container buildah-andrey-test-image*

**Podman**

*podman  images*

*podman pull centos*

*podman rmi image-id*

*podman inspect container-id*

**Skopeo**

*skopeo inspect docker://registry.fedoraproject.org/fedora:latest*

*skopeo inspect --config docker://registry.fedoraproject.org/fedora:latest  | jq*

*skopeo copy docker://quay.io/buildah/stable docker://registry.internal.company.com/buildah*

*skopeo copy docker://registry.fedoraproject.org/fedora:latest   docker://registry.hub.docker.com/24may/home-task5:latest*

## cri-o

*minikube start --container-runtime=crio*

## psp-advisor

*kubectl apply -f example-psp.yaml*

*kubectl get psp*

`$ git clone https://github.com/sysdiglabs/kube-psp-advisor
$ cd kube-psp-advisor && make build`

*./kube-psp-advisor --namespace=psp-test*

`$ ./kube-psp-advisor --namespace psp-test > psp-test.yaml && cat psp-test.yaml
$ kubectl apply -f psp-test.yaml`

## For report

*./kube-psp-advisor --namespace=psp-test --report | jq .podSecuritySpecs*

## FALCO

*wget https://dl.bintray.com/falcosecurity/deb/stable/falco-0.23.0-x86_64.deb*

*sudo dpkg -i falco-0.23.0-x86_64.deb*

`docker pull falcosecurity/falco-driver-loader:latest
docker run --rm -i -t \
    --privileged \
    -v /root/.falco:/root/.falco \
    -v /proc:/host/proc:ro \
    -v /boot:/host/boot:ro \
    -v /lib/modules:/host/lib/modules:ro \
    -v /usr:/host/usr:ro \
    -v /etc:/host/etc:ro \
    falcosecurity/falco-driver-loader:latest`

*falcoctl convert psp --psp-path test_psp.yaml --rules-path psp_rules.yaml*

*falco -r psp_rules.yaml*
