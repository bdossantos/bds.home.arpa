```
mkdir -p mibs
rsync -zav router.bds.home.arpa:/usr/share/snmp/mibs/* mibs/
git clone https://github.com/prometheus/snmp_exporter.git || true
pushd snmp_exporter/generator
git pull
make mibs
popd
rsync -zav snmp_exporter/generator/mibs mibs/
docker run -v "${PWD}:/opt/" prom/snmp-generator generate
```
