# arm-webdav
A Webdav server for Raspberry Pi based on Apache

To start the container with default config :
```bash
docker run -d -P arm-webdav
```

But you can also use your local datastore :
```bash
docker run -d -P -v <your local datastore 1>:/data -v <your local datastore 2>:/config arm-webdav
```

The default login is : "default / passw0rd"

To change this, run :
```bash
htdigest /config/apache/user.passwd DAV-upload default
```

Tributes to https://github.com/Undergrid/docker-apache-webdav.


