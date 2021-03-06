#!/bin/bash

###
### THIS SCRIPT LISTS PATTERNS FOR THE ORGANIZATION 
###
### CONSUMES THE FOLLOWING ENVIRONMENT VARIABLES:
###
### + HZNMONITOR_EXCHANGE_URL
### + HZNMONITOR_EXCHANGE_ORG
### + HZNMONITOR_EXCHANGE_APIKEY
###

if [ -z $(command -v jq) ]; then
  echo "*** ERROR $0 $$ -- please install jq"
  exit 1
fi

if [ -z "${HZNMONITOR_EXCHANGE_URL:-}" ]; then HZNMONITOR_EXCHANGE_URL="http://exchange:3090/v1"; fi

if [ -z "${HZNMONITOR_EXCHANGE_APIKEY:-}" ] || [ "${HZNMONITOR_EXCHANGE_APIKEY:-}" == "null" ]; then
  echo "*** ERROR $0 $$ -- invalid HZNMONITOR_EXCHANGE_APIKEY" &> /dev/stderr
  exit 1
fi
  
if [ -z "${HZNMONITOR_EXCHANGE_ORG:-}" ] || [ "${HZNMONITOR_EXCHANGE_ORG:-}" == "null" ]; then
  echo "*** ERROR $0 $$ -- invalid HZNMONITOR_EXCHANGE_ORG" &> /dev/stderr
  exit 1
fi

curl -sL -u "${HZNMONITOR_EXCHANGE_ORG}/${HZNMONITOR_EXCHANGE_USER:-iamapikey}:${HZNMONITOR_EXCHANGE_APIKEY}" "${HZNMONITOR_EXCHANGE_URL%/}/orgs/${HZNMONITOR_EXCHANGE_ORG}/patterns" \
  | jq '{"exchange":"'${HZNMONITOR_EXCHANGE_URL}'","org":"'${HZNMONITOR_EXCHANGE_ORG}'","user":"'${HZNMONITOR_EXCHANGE_USER}'","patterns":[.patterns|to_entries[]|.value.id=.key|.value]|sort_by(.lastUpdated)|reverse}'
