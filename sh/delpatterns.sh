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

if [ -z "${HZN_EXCHANGE_APIKEY:-}" ] || [ "${HZN_EXCHANGE_APIKEY:-}" == "null" ]; then
  echo "*** ERROR $0 $$ -- invalid HZN_EXCHANGE_APIKEY" &> /dev/stderr
  exit 1
fi
  
if [ -z "${HZN_ORG_ID:-}" ] || [ "${HZN_ORG_ID:-}" == "null" ]; then
  echo "*** ERROR $0 $$ -- invalid HZN_ORG_ID" &> /dev/stderr
  exit 1
fi

for pattern in $(curl -sL -u "${HZN_ORG_ID}/${HZN_USER_ID:-${USER}}:${HZN_EXCHANGE_APIKEY}" "${HZN_EXCHANGE_URL%/}/orgs/${HZN_ORG_ID}/patterns" | jq -r '(.patterns|to_entries[]|.value.id=.key|.value).id'); do
  id=${pattern##*/}
  if [ ! -z "${1:-}" ]; then
    if [[ "${id}" =~ "${1}" ]]; then 
      if [ "${DEBUG:-}" = true ]; then echo "--- INFO $0 $$ -- matched: ${id}" &> /dev/stderr; fi
      match=true
    else
      match=false
    fi
  else
    match=true
  fi
  if [ "${match:-false}" = true ]; then
    echo "--- INFO $0 $$ -- deleting pattern: ${id}" &> /dev/stderr
    curl -sL -X DELETE -u "${HZN_ORG_ID}/${HZN_USER_ID:-${USER}}:${HZN_EXCHANGE_APIKEY}" "${HZN_EXCHANGE_URL%/}/orgs/${HZN_ORG_ID}/patterns/${id}"
  fi
done
