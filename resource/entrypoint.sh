#!/bin/sh
set -e

# 设置最终使用IP
if [ -z "$IP" ]; then
  echo "没有设置IP!"
  exit 1
fi

LISTENERS="PLAINTEXT://0.0.0.0:9092"
ADVERTISED_LISTENERS="PLAINTEXT://localhost:9092"

# 设置明文端口时监听配置
if [ ! -z "$PLAINTEXT_PORT" ]; then
  ADVERTISED_LISTENERS="PLAINTEXT://${IP}:${PLAINTEXT_PORT}"
fi

# 设置TLS端口时监听配置
if [ ! -z "$SSL_PORT" ]; then
  LISTENERS="${LISTENERS},SSL://0.0.0.0:9093"
  ADVERTISED_LISTENERS="${ADVERTISED_LISTENERS},SSL://${IP}:${SSL_PORT}"
fi

# 设置密钥库密码
if [ -z "$KEYSTORE_PASSWORD" ]; then
  KEYSTORE_PASSWORD="123456"
fi

# 显示信息
echo "LISTENERS:            ${LISTENERS}"
echo "ADVERTISED_LISTENERS: ${ADVERTISED_LISTENERS}"

# 改为使用--override方式设置
# # 替换(注意：变量中的/前面要加\转义！)
# KAFKA_CONFIG="/server/kafka/config/server.properties"
# sed -i "s/listeners=.*/listeners=${LISTENERS}/g" ${KAFKA_CONFIG}
# sed -i "s/advertised.listeners=.*/advertised.listeners=${ADVERTISED_LISTENERS}/g" ${KAFKA_CONFIG}
# sed -i "s/ssl.keystore.password=.*/ssl.keystore.password=${KEYSTORE_PASSWORD}/g" ${KAFKA_CONFIG}

# 异常关闭后,如果不清理此目录,会因为broker.id重复而造成kafka无法启动.
rm -rf /server/data/zookeeper
# 异常关闭后,如果不清理此目录,会因为meta.properties中的clusterId不匹配而造成kafka无法启动.
rm -rf /tmp/kafka-logs

# 启动服务
/server/zookeeper/bin/zkServer.sh start-foreground &
/server/kafka/bin/kafka-server-start.sh -daemon ${KAFKA_CONFIG} \
   --override listeners=${LISTENERS} \
   --override advertised.listeners=${ADVERTISED_LISTENERS} \
   --override ssl.keystore.password=${KEYSTORE_PASSWORD}

#Don`t exit!
tail -f /dev/null
