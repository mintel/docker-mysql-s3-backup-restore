#!/bin/bash

yel=$'\e[1;33m'
red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
end=$'\e[0m'

if [ -z "${AWS_ACCESS_KEY}" ]; then
    printf "%s\n" "${red}ERROR: The environment variable AWS_ACCESS_KEY is not set.${end}"
    exit 1
fi

if [ -z "${AWS_SECRET_KEY}" ]; then
    printf "%s\n" "${red}ERROR: The environment variable AWS_SECRET_KEY is not set.${end}"
    exit 1
fi

if [ -z "${AWS_HOST_BUCKET}" ]; then
    printf "%s\n" "${red}ERROR: The environment variable AWS_HOST_BUCKET is not set.${end}"
    exit 1
fi

if [ -z "${AWS_HOST_BASE}" ]; then
    printf "%s\n" "ERROR: The environment variable AWS_HOST_BASE is not set.${end}"
    exit 1
fi

if [ -z "${AWS_S3_RESTORE_SQL_FILE}" ]; then
    printf "%s\n" "ERROR: The environment variable AWS_S3_RESTORE_SQL_FILE is not set.${end}"
    exit 1
fi

if [ -z "${MYSQL_USER}" ]; then
    printf "%s\n" "ERROR: The environment variable MYSQL_USER is not set.${end}"
    exit 1
fi

if [ -z "${MYSQL_PASSWORD}" ]; then
    printf "%s\n" "ERROR: The environment variable MYSQL_PASSWORD is not set.${end}"
    exit 1
fi

if [ -z "${MYSQL_HOST}" ]; then
    printf "%s\n" "ERROR: The environment variable MYSQL_HOST is not set.${end}"
    exit 1
fi

if [ -z "${MYSQL_DATABASE}" ]; then
    printf "%s\n" "ERROR: The environment variable MYSQL_DATABASE is not set.${end}"
    exit 1
fi


echo "" >> /root/.s3cfg
echo "access_key=${AWS_ACCESS_KEY}" >> /root/.s3cfg
echo "secret_key=${AWS_SECRET_KEY}" >> /root/.s3cfg
echo "host_bucket=${AWS_HOST_BUCKET}" >> /root/.s3cfg
echo "host_base=${AWS_HOST_BASE}" >> /root/.s3cfg

printf "Written s3config to /root/.s3cfg\n"

printf "Check MySQL at ${MYSQL_HOST} is alive..."
mysql -h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} mysql -e "show databases" >/dev/null || exit 1
printf "%s\n" "${green}OK${end}"

printf "Checking S3 restore-file '${AWS_S3_RESTORE_SQL_FILE}' exists..."
s3cmd ls ${AWS_S3_RESTORE_SQL_FILE} >/dev/null || exit 1
printf "%s\n" "${green}OK${end}"

/root/restore || exit 1
