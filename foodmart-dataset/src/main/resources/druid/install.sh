#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to you under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

cd ~

export DRUID=0.9.2
export ZK=3.4.6

echo Removing previous Zookeeper
rm -rf zookeeper-${ZK}

echo Install and start Zookeeper
(
 if [ ! -f /var/cache/apt/archives/zookeeper-${ZK}.tar.gz ]; then
   curl --silent http://www.gtlib.gatech.edu/pub/apache/zookeeper/zookeeper-${ZK}/zookeeper-${ZK}.tar.gz -o /var/cache/apt/archives/zookeeper-${ZK}.tar.gz
 fi
 tar -xzf /var/cache/apt/archives/zookeeper-${ZK}.tar.gz
 cd zookeeper-${ZK}
 cp conf/zoo_sample.cfg conf/zoo.cfg
 ./bin/zkServer.sh start
)

echo Removing previous Druid
rm -rf druid-${DRUID}

echo Installing Druid
if [ ! -f /var/cache/apt/archives/druid-${DRUID}-bin.tar.gz ]; then
  curl --silent http://static.druid.io/artifacts/releases/druid-${DRUID}-bin.tar.gz -o /var/cache/apt/archives/druid-${DRUID}-bin.tar.gz
fi
tar -xzf /var/cache/apt/archives/druid-${DRUID}-bin.tar.gz
cd druid-${DRUID}
bin/init

ln -s /dataset/druid/foodmart .
ln -s /dataset/druid/run.sh .
ln -s /dataset/druid/index.sh .
ln -s /dataset/druid/query.sh .

echo Starting Druid
./run.sh
echo Index foodmart and wiki data sets
./index.sh
sleep 300
echo Run a query
./query.sh
echo Completed Druid start up

# End
