#!/bin/bash

###
### THIS SCRIPT LISTS SERVICES FOR THE ORGANIZATION 
###
### CONSUMES THE FOLLOWING ENVIRONMENT VARIABLES:
###
### + HZN_EXCHANGE_URL
### + HZN_ORG_ID
### + HZN_EXCHANGE_APIKEY
###

if [ -z $(command -v jq) ]; then
  echo "*** ERROR $0 $$ -- please install jq"
  exit 1
fi

if [ -z "${HZN_EXCHANGE_URL:-}" ]; then HZN_EXCHANGE_URL="http://exchange:3090/v1"; fi

if [ -z "${HZN_EXCHANGE_APIKEY:-}" ] || [ "${HZN_EXCHANGE_APIKEY:-null}" = 'null' ]; then
  echo "*** ERROR $0 $$ -- invalid HZN_EXCHANGE_APIKEY" &> /dev/stderr
  exit 1
fi
  
if [ -z "${HZN_ORG_ID:-}" ] || [ "${HZN_ORG_ID:-}" == "null" ]; then
  echo "*** ERROR $0 $$ -- invalid HZN_ORG_ID" &> /dev/stderr
  exit 1
fi

curl -sL -u "${HZN_ORG_ID}/${HZN_USER_ID:-${USER}}:${HZN_EXCHANGE_APIKEY}" "${HZN_EXCHANGE_URL%/}/orgs/${HZN_ORG_ID}/services" \
  | jq '{"exchange":"'${HZN_EXCHANGE_URL}'","org":"'${HZN_ORG_ID}'","services":[.services|to_entries[]|.value.id=.key|.value]|sort_by(.lastUpdated)|reverse}'
