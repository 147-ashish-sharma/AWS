### This is script for syncing S3 bucket to an EC@ instance
# Considerations:
# 1. Instance is already having suitable IAM roles for pulling data
#
# Script for syncing S3 logs to awslogs directory
#!/bin/bash
mkdir awglogs
cat <<EOF > alb_logs_download.sh
/usr/bin/aws s3 sync s3://demo-msfssalb/AWSLogs/860384218481/elasticloadbalancing/eu-west-2/2018/06/07/ awslogs/
a=`ls awslogs/*.gz | cut -d"/" -f2`
for i in $a; do cp ~/awslogs/$i ~/unzipped_logs/$i; gunzip ~/unzipped_logs/$i; done
EOF

# Inputting cron for syncing S3 every five minutes
echo "*/5 * * * * /home/ec2-user/alb_logs_download.sh" | tee -a /var/spool/cron/ec2-user
