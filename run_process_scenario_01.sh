#!/bin/bash

echo ""

echo Conditional Event: Start Process
curl --location --request POST 'http://localhost:8080/rest/condition' --header 'Content-Type: application/json' --data-raw '{
  "variables" : {
    "processStarted" : {"value" : true, "type": "boolean"},
    "userTask1Started" : {"value" : "false", "type": "boolean"},
    "userTask2Started" : {"value" : "false", "type": "boolean"},
    "processContinue" : {"value" : "false", "type": "boolean"},
    "conditionalEventSubProcess1": {"value" : "false", "type": "boolean"},
    "conditionalEventSubProcess2": {"value" : "false", "type": "boolean"}
  },
  "businessKey": "process-key-123"
}'
sleep 5
echo ""

echo Conditional Event: Conditional Boundary Event Non-Interrupting

PROCESS_ID=$(curl --location --fail --silent --request GET 'http://localhost:8080/rest/process-instance' --header 'Content-Type: application/json' --data-raw '{ "businessKey": "process-key-123"}' | jq -r '.[0].id')

curl --location --fail --silent --request POST "http://localhost:8080/rest/process-instance/$PROCESS_ID/variables" --header 'Content-Type: application/json' --data-raw '{
  "modifications":
    {"userTask1Started": {"value" : true, "type": "boolean"}},
  "deletions": []
  }'

sleep 5


echo Conditional Event: Complete User Task 1
TASK_ID=$(curl --location --fail --silent --request POST 'http://localhost:8080/rest/task' --header 'Content-Type: application/json' --data-raw '{ "processInstanceBusinessKey": "process-key-123", "taskDefinitionKey": "user-task-1"}' | jq -r '.[0].id')

curl --location --fail --silent --request POST "http://localhost:8080/rest/task/$TASK_ID/complete" --header 'Content-Type: application/json'

sleep 5


echo Conditional Event: Conditional Intermediate Catch Event
curl --location --fail --silent --request POST "http://localhost:8080/rest/process-instance/$PROCESS_ID/variables" --header 'Content-Type: application/json' --data-raw '{
  "modifications":
    {"processContinue": {"value" : true, "type": "boolean"}},
  "deletions": []
  }'


echo Conditional Event: Conditional Boundary Event Interrupting


curl --location --fail --silent --request POST "http://localhost:8080/rest/process-instance/$PROCESS_ID/variables" --header 'Content-Type: application/json' --data-raw '{
  "modifications":
    {"userTask2Started": {"value" : true, "type": "boolean"}},
  "deletions": []
  }'

sleep 5