# !/bin/bash

set -e

cd "$(dirname "$0")"

echo "extraindo base"
python3 extrai_base.py
sleep 10
echo "removendo arquivo antigo"
gsutil rm gs://geinfo-previne-indicadores/ind_1_2_3/listagem/base*.csv
sleep 5 
echo "subindo novo arquivo"
gsutil -h "Content-Type:text/plain" cp base*.csv gs://geinfo-previne-indicadores/ind_1_2_3/listagem/
sleep 10 
echo "removendo restos"
rm base*.csv 
sleep 10
