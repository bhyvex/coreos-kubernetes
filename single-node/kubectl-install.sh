#!/bin/bash
set -e

PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
K8S_VER=v1.0.6
KUB_URL="https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/bin/${PLATFORM}/amd64/kubectl"

target_dir="../../../../mist.core"
vagrant_dir=`pwd`

echo
function configure_kubectl () {
    cd ${target_dir}
    echo "==> mist_step: Configuring kubectl context for vagrant"

    ./kubectl config set-cluster vagrant --server=https://172.17.4.99:443 --certificate-authority=${vagrant_dir}/ssl/ca.pem

    ./kubectl config set-credentials vagrant-admin --certificate-authority=${vagrant_dir}/ssl/ca.pem --client-key=${vagrant_dir}/ssl/admin-key.pem --client-certificate=${vagrant_dir}/ssl/admin.pem

    ./kubectl config set-context vagrant --cluster=vagrant --user=vagrant-admin

    cd ${vagrant_dir}

}

function use_context () {
    echo "==> mist_step: kubectl use vagrant context"
    cd ${target_dir}
    ./kubectl config use-context vagrant
    cd ${vagrant_dir}
}

function download () {

    if [ -f ${target_dir}/kubectl ]; then
        # kubectl already exists
        :
    else
        echo "==> mist_step: Downloading kubectl ${K8S_VER} for ${PLATFORM}. This may take a minute, depending on your internet speed."
        wget -q --no-check-certificate -L -O ${target_dir}/kubectl "${KUB_URL}"
        chmod +x ${target_dir}/kubectl
    fi
}

download
configure_kubectl
use_context
echo "==> mist_warning: If this is your first time provisioning the vms, the kubeserver will need some minutes to be up and running"
