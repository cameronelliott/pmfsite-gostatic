title: Cannot read property getUserMedia of undefined
date: 2020-12-28
path: /foo
----


[HLS]: https://foo




## How can my navigator.mediaDevices be null??? ... What?

I suspect you are using the Chrome browser, and your trying to access the camera
or other media device.

Well, if you look at your address bar, are you using HTTP or HTTPS?

If you see that you are using HTTP, you have found the culprit my friend.

You see, Chrome won't let you access the camera, or other mediaDevices when you
load your page using HTTP, you need to use HTTPS.

Whats the quickest way to do that?

Thats a good question.

Apparently there are some ways to do this if you are accessing localhost.

[Stackoverflow:Getting Chrome to accept self-signed localhost certificate](https://stackoverflow.com/a/31900210/86375)

But if you're like me and you use a Mac to access a Linux box, things get a little trickier.
In that case your not using localhost, so the tricks to allow SSL to localhost won't work.

I'm going to explain how I got a cert for my private IP.

## Getting a TLS/SSL cert for Let's Encrypt and the Caddy webserver

So, here is how I did it.

My linux box lives at `192.168.86.4`

First, I signed up at [DuckDns](https://www.duckdns.org)

Then I went to the [domains page](https://www.duckdns.org/domains)
and I created a hostname and mapped it to 192.168.86.4

Next, I got my DuckDns token, it's under the triple-vertical-bar icon in
the upper right to the right of your login name.
It is a typical GUID type auth token.
Save this, you'll need it in a minute.

I recommend Caddy as the webserver to get this going with.

Here is the link to the article on building Caddy for DuckDns or other
providers: [https://caddy.community/t/how-to-use-dns-provider-modules-in-caddy-2/8148](link)

I then went to the Caddy custom download [packager tool](https://caddyserver.com/download), and then:
1. selected my platform for my build
2. selected DuckDns as the plugin to be bundled into my binary

I downloaded and installed Caddy:

```bash
sudo mv caddy_linux_amd64_custom /usr/local/bin/caddy
sudo chown root:root /usr/local/bin/caddy
sudo chmod 755 /usr/local/bin/caddy
sudo setcap ‘cap_net_bind_service=+ep’ /usr/local/bin/caddy
```

The last command gives Caddy permissions to bind to ports 80 and 443, which it wouldn't
be able to do unless you run it as super user. 
You might not need these, depending on how you configure your Caddyfile,
if you specify a port above 1024, you don't need to enable Caddy to bind to the low ports.

Then create your Caddy config file.
Name it 'Caddyfile'

```Caddyfile
hostname.duckdns.org:8000

tls {
    dns duckdns xxxx-xxxx-xxxx--xxx-xx-xxx-x
}

file_server
```


Finally, run Caddy:
```bash
$ caddy run
```

You should be good to go with SSL/TLS, which will allow Chrome to access the camera.









