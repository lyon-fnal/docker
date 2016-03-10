sudo mount -t cvmfs gm2.opensciencegrid.org /cvmfs/gm2.opensciencegrid.org

sudo bash -c "echo  '/cvmfs/gm2.opensciencegrid.org *(ro,sync,no_root_squash,no_subtree_check,fsid=101)' > /etc/exports"
sudo chkconfig nfs on
sudo rpcbind start
sudo service nfs start
sudo exportfs -a
sudo service nfs restart
