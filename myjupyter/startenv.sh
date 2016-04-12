setuproot6 () {
  source /home/gm2/root_v6.06.02/build/bin/thisroot.sh
  echo "root now runs root6"
}

source /products/setup
setup art v1_17_07 -q prof:e9
setup cmake v3_3_2

echo 'To run root6, do "setuproot6"'
