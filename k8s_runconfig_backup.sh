#!/bin/bash

# Backup a kubernetes cluster's running config and  and version it

namespace=brightname
version_suffix=$(date +%y%m%d%H%M)
config_dir=/etc/kubernetes/manifests/backup/$namespace.$version_suffix
running_config=/etc/kubernetes/manifests/$namespace.RUNNING
k8s_config_items="serviceaccounts roles priorityclasses endpoints statefulset deployment service pv pvc configmap secrets cronjobs"
BACKUP_MANIFESTS=true


if $BACKUP_MANIFESTS ; then
        namespaces="$namespace kube-system"
        for ns in $namespaces
        do
	            echo "backing up manifests"
	            for k8s_config_item in $k8s_config_items
	            do
	                dir=${config_dir}/$ns/${k8s_config_item}
	                [ -d $dir ] || mkdir -p $dir

	                for item  in $(kubectl -n $ns get ${k8s_config_item} |awk '$1 !~ /NAME/ {print $1}'|grep -v NAME)
	                do
	                    kubectl -n $ns get $k8s_config_item $item  -o yaml > $dir/${item}.yaml
	                done
	                    unset dir
	            done
        done
fi
