FROM fstab/aws-cli

USER root
RUN apt-get update && apt-get install -y jq

USER aws
COPY ./cpuavgs.sh /home/aws/

WORKDIR /home/aws
CMD ./cpuavgs.sh > /home/aws/output/`date +"%s"`.csv
