#!/usr/bin/env bash
# Run root
# $1 = {connection_file}  (from Jupyter)
# $2 = version string (e.g. v6_06_02)
# $3 = qualifier (e.g. "e9:prof")
# $4 = startup string

source setupRoot "$PYTHON_DATA_PLATFORM_2710" "$2" "$3" 
python -m ipykernel -f $1 -c "$4"
