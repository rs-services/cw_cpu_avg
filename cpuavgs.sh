#!/usr/bin/env bash

export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}
start_time=$(date --date="14 days ago" +"%Y-%m-%dT00:00:00Z")
end_time=$(date +"%Y-%m-%dT00:00:00Z")

if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" ]]; then
  >&2 echo "No AWS credentials provided, please set environment variables named AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY"
  exit 1
fi

>&2 echo "Finding the total average CPU use for each instance in $AWS_DEFAULT_REGION, between $start_time and $end_time"

instances=$(/home/aws/aws/env/bin/aws ec2 describe-instances)
instance_ids=$(echo $instances | jq -r '.Reservations[].Instances[].InstanceId')

>&2 echo "Found these instances"
>&2 echo $instance_ids

for instance_id in $instance_ids; do
  metrics=$(/home/aws/aws/env/bin/aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization --start-time "$start_time" --end-time "$end_time" --period 1209600 --statistic Maximum --dimensions Name=InstanceId,Value=$instance_id)
  avg_cpu=$(echo $metrics | jq '.Datapoints[].Maximum')
  echo "$instance_id,$avg_cpu"
done
