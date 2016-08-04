# cw_cpu_avg
Fetches CPU average (using CloudWatch) for every EC2 instance in a specified region, creates a CSV file with the instance ID and it's average CPU usage.

It goes back precisely 14 days from "today" (the default maximum history in CloudWatch) to fetch this average.

## usage
Everything necessary to run the script `cpuavgs.sh` is encapsulated in the docker image which would be built by the Dockerfile.

The docker image will write the csv output to `/home/aws/output/<unixtimestamp>.csv`, so if you'd like to fetch the output, make sure to map a volume there.

If you're familiar with Docker, and have it installed, you should be able to effectively do just this.
```
docker build -t cw_cpu_avg .
docker run --rm -it -e AWS_ACCESS_KEY_ID=<your access key id> -e AWS_SECRET_ACCESS_KEY=<your access key> -v `pwd`:/home/aws/output cw_cpu_avg
```
