#!/usr/bin/env bash -e

# This script will import OpenNMS NetFlow dashboards into Kibana
# It requires access to Kibana with a given URL and credentials.

KIBANA_URL="http://localhost:5601"
KIBANA_IMPORT_ENDPOINT="/api/kibana/dashboards/import"
CURL=$(which curl)
DIR=netflow_v5

checkRequirements() {
  if [[ ! -x "${CURL}" ]]; then
    echo "The curl binary in ${CURL} is does not exist or is executable."
    exit 1
  fi
}

print_usage() {
  echo "
Load OpenNMS Netflow dashboards, visualizations and related search objects into Kibana.
Usage: $(basename "$0") -url ${KIBANA_URL} -user admin:secret.
Options:
  -h | --help
    Print the help menu.
  -e | --endpoint
    Set the ReST API endpoint. Default is: ${KIBANA_IMPORT_ENDPOINT}
  -l | --url
    Kibana URL. Default is: ${KIBANA_URL}.
  -u | --user
    Username and password for authenticating to Elasticsearch using Basic
    Authentication. The username and password should be separated by a
    colon (i.e. "admin:secret"). By default no username and password are
    used.
" >&2
}

while [ "${1}" != "" ]; do
case ${1} in
    -h | --help )
        print_usage
        exit 0
        ;;

    -e | --endpoint )
        KIBANA_IMPORT_ENDPOINT=${2}
        if [ "${KIBANA_IMPORT_ENDPOINT}" = "" ]; then
            echo "Error: Missing Kibana ReST endpoint"
            print_usage
            exit 1
        fi
        ;;

    -l | --url )
        KIBANA_URL=$2
        if [ "${KIBANA_URL}" = "" ]; then
            echo "Error: Missing Kibana URL"
            print_usage
            exit 1
        fi
        ;;

    -u | --user )
        USER=$2
        if [ "$USER" = "" ]; then
            echo "Error: Missing username"
            print_usage
            exit 1
        fi
        CURL="${CURL} --user ${USER}"
        ;;

     *)
        echo "Error: Unknown option $2"
        print_usage
        exit 1
        ;;

esac
shift 2
done

checkRequirements

for dashboard in ${DIR}/*.json; do
  ${CURL} -s -o /dev/null -w "Import ${dashboard} status: %{http_code}\n" -XPOST -H 'Content-Type:application/json' -H 'kbn-xsrf:true' ${KIBANA_URL}${KIBANA_IMPORT_ENDPOINT} -d @${dashboard}
done
