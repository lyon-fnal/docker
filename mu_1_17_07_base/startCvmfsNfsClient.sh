# Start the NFS client

sudo mkdir -p /cvmfs/gm2.opensciencegrid.org
sudo mkdir -p /cvmfs/fermilab.opensciencegrid.org

sudo showmount -e ${NFS_SERVER_IP}
sudo mount -t nfs -o nfsvers=3,nolock,noatime,ac,actimeo=60 ${NFS_SERVER_IP}:/cvmfs/gm2.opensciencegrid.org  /cvmfs/gm2.opensciencegrid.org
sudo mount -t nfs -o nfsvers=3,nolock,noatime,ac,actimeo=60 ${NFS_SERVER_IP}:/cvmfs/fermilab.opensciencegrid.org  /cvmfs/fermilab.opensciencegrid.org
