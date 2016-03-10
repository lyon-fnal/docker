# Functions for g-2 development

# restore_env -- restore the environment from a gm2.env file
restore_gm2 () {
  # Determine path
  d=$PWD
  if [[ $# -eq 1 ]] ; then
    d=$1
  fi

  while read line; do
    export "$line"
  done < $d/gm2.env

  echo "Environment restored: MRB_BUILDDIR=$MRB_BUILDDIR"
}

# Set the environment - change .bashrc to load gm2.env
autoenv_gm2 () {
  d=$PWD
  if [[ $# -eq 1 ]] ; then
    d=$1
  fi
  echo "restore_gm2 $d" >> ~/.bashrc
}

# capture_gm2 -- capture the environment - write to gm2.env file
capture_gm2 () {
  env | egrep -v '^HOSTNAME=' | egrep -v '^BASH_FUNC|^DISPLAY|^affinity|^PWD' | \
        egrep -v '^}$'  > gm2.env

  echo "Wrote environment to gm2.env"
  autoenv_gm2
}

# setup_gm2 --- setup an existing environment
setup_gm2 () {

  source /cvmfs/gm2.opensciencegrid.org/prod/g-2/setup

  cd $1

  if [[ $# -eq 1 ]] ; then
    LOCALPROD=localProd*
  else
    LOCALPROD=$2
  fi
  source $LOCALPROD/setup

  source mrb s
  cd $MRB_BUILDDIR
  setup ninja v1_5_3a
  capture_gm2
}
