## 文件

* `证书库` 放置服务器证书密钥及其根证书, 对应内部路径`/server/ssl/keystore.jks`

## 端口

* `9092` 明文
* `9093` 加密且验证客户端证书

## 环境变量

* `IP` 最终提供服务IP, 如要公网使用此处设置公网IP
* `PLAINTEXT_PORT` 非加密端口, 对应内部端口`9092`
* `KEYSTORE_PASSWORD` 证书库密码
* `SSL_PORT` 加密端口, 对应内部端口`9093`

### 构建

```
$ docker build -t registry.cn-shanghai.aliyuncs.com/xm69/kafka:2.7 .
```

### 运行

```
$ docker run -d --restart=always \
  -p 39092:9092 \
  -p 39093:9093 \
  -v "$PWD/kafka.keystore.jks":/server/ssl/keystore.jks \
  -e IP="192.168.1.200" \
  -e PLAINTEXT_PORT="39092" \
  -e KEYSTORE_PASSWORD="123456" \
  -e SSL_PORT="39093" \
  --name "kafka" registry.cn-shanghai.aliyuncs.com/xm69/kafka:2.7
```
> 不启用TLS时，不要设置`KEYSTORE_PASSWORD`和`SSL_PORT`。
