#!/bin/bash

key=$1

allRequest=`cat localhost_access_log.$key|wc -l`
allPostRequest=`cat localhost_access_log.$key*|grep 'POST'|wc -l`
crmRequest=`cat localhost_access_log.$key*|grep 'crm'|wc -l`
crmPostRequest=`cat localhost_access_log.$key*|grep 'POST /crm'|wc -l`
billRequest=`cat localhost_access_log.$key*|grep 'billing'|wc -l`
billPostRequest=`cat localhost_access_log.$key*|grep 'POST /billing'|wc -l`
SQLRequest=`cat localhost_access_log.$key*|grep 'SQL'|wc -l`
allCDRRequest=`cat localhost_access_log.$key*|grep 'CDR'|wc -l`
CDRRequest=`cat localhost_access_log.$key*|grep 'CDR '|wc -l`
CDRComplexRequest=`cat localhost_access_log.$key*|grep 'CDRComplex'|wc -l`
openAcctountRequest=`cat localhost_access_log.$key*|grep 'open'|wc -l`
countSort=`cat localhost_access_log.$key*|grep 'POST'|awk '{print $7}'|sort|uniq -c|sort -nr`

echo "所有请求数:$allRequest"
echo "所有POST请求:$allPostRequest"
echo "所有CRM请求:$crmRequest"
echo "所有CRM POST请求:$crmPostRequest"
echo "所有BILLING请求:$billRequest"
echo "所有BILLING POST请求:$billPostRequest"
echo "SQL生成量:$SQLRequest"
echo "话单生成量:$allCDRRequest"
echo "简版话单生成量:$CDRRequest"
echo "详版话单生成量:$CDRComplexRequest"
echo "crm开户量:$openAcctountRequest"
echo "使用次数排序:"
echo "$countSort"
