#!/bin/bash

if [ "$ENV" == "production" ]
then
  host='https://hobbycatcher-api.herokuapp.com'
else
  host='http://host.docker.internal:9090'
fi

curl --request GET "${host}/api/v1/scheduler"