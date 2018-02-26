# Kibana Flow Dashboards for OpenNMS Horizon

This repsitory allows you to setup dashboards to visualize OpenNMS Horizon collected flow data.
Following dashboards are available:

## NetFlow Version 5

* _Overview_: Basic IP traffic overview 
* _Autonomous Systems_: Traffic statistics related to autonomous systems
* _Conversation Partners_: Visualize traffic statistics between systems 
* _Flow Exporter_: Overview about traffic from devices exporting flow data
* _Flow Records_: Statistics about raw Flow records processed by the system
* _Top-N_: Top-N report about overall generated network traffic 
* _Traffic Analysis_: Detailed traffic analysis

Kibana dashboard get imported using the Kibana ReST API and are stored in JSON format.

## Requirements

* Kibana 6.1.1
* ElasticSearch 6.1.1
* OpenNMS Horizon feature branch "Drift"

## Installation

To install the dashboards the `load.sh` can be used.
By default the Kibana ReST endpoint is used at _localhost:5601_.

The script usage to customize the URL for the ReST endpoint can be shown with

```
./load.sh --help
```

Installing dashboards in a remote Kibana application:

```
git clone https://github.com/opennms-forge/kbn-flow-dashboards.git
cd kbn-flow-dashboards
./load.sh -l http://<my-kibana-host>:5601
``` 

## Exporting Dashboards and Contribution

If you want to contribute to this repository, you can export the dashboard referenced by the internal UUID (e.g. d7716370-0cb0-11e8-88ba-8d82bf9f2249) with the following command:

```
curl 'http://<my-kibana-host>.org:5601/api/kibana/dashboards/export?dashboard=d7716370-0cb0-11e8-88ba-8d82bf9f2249' -o your-friendly-dashboard-name.json
```

[Fork](https://help.github.com/articles/fork-a-repo/) this repository and add the dashboard into the `netflow_v5` directory and create a [Pull Request](https://help.github.com/articles/creating-a-pull-request/).

## Credits

Dashboards are heavily influenced by the [Logstash project](https://github.com/elastic/logstash/tree/master/modules/netflow/configuration/kibana/6.x)

## License
 Apache License, Version 2.0
