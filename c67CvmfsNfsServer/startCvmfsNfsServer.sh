/usr/local/bin/startCvmfs.sh

sudo bash -c "echo  '/cvmfs/gm2.opensciencegrid.org *(ro,sync,no_root_squash,no_subtree_check,fsid=101)' > /etc/exports"
sudo bash -c "echo  '/cvmfs/fermilab.opensciencegrid.org *(ro,sync,no_root_squash,no_subtree_check,fsid=102)' >> /etc/exports"
sudo chkconfig nfs on
sudo rpcbind start
sudo service nfs start
sudo exportfs -a
sudo service nfs restart
