#  支付对接demo

前提是我们已经创建好了一个商户应用，名称就是 炫富。

并且我们通过指令:
```bash
openssl genrsa -out private_key.pem 2048
openssl rsa -in private_key.pem -outform PEM -pubout -out public.pem
//Create a certificate signing request with the private key
openssl req -new -key private_key.pem -out rsaCertReq.csr

//Create a self-signed certificate with the private key and signing request
openssl x509 -req -days 3650 -in rsaCertReq.csr -signkey private_key.pem -out rsaCert.crt

//Convert the certificate to DER format: the certificate contains the public key
openssl x509 -outform der -in rsaCert.crt -out rsaCert.der

//Export the private key and certificate to p12 file
openssl pkcs12 -export -out rsaPrivate.p12 -inkey private_key.pem -in rsaCert.crt
```

密码都为 123456 。

platform.pem 是平台公钥，使用下面指令

```bash
openssl x509 -in platform.pem -inform pem -outform der -out platform.der
```
获得 platform.der
