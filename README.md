# Kamailio SIP Server

* https://www.kamailio.org/

```sh
# Build Image
docker build -t ageet/kamailio .

# Run Kamailio
docker run -d -p 5060-5061:5060-5061 -p 5060:5060/udp -e EXTERNAL_IP=<host_ip> ageet/kamailio
```
