title: Setup Coturn Using Docker and Short Term Credentials
date: 2020-12-01
tags: Stun/Turn
----


[HLS]: https://foo



- [Introduction](#introduction)
- [Get a Digital Ocean droplet running with Docker](#get-a-digital-ocean-droplet-running-with-docker)
- [If you are not using DO, you must install Docker](#if-you-are-not-using-do-you-must-install-docker)
- [Log into your virtual machine](#log-into-your-virtual-machine)
- [Open a hole in the firewall on VM](#open-a-hole-in-the-firewall-on-vm)
- [Start Coturn with a shared secret key](#start-coturn-with-a-shared-secret-key)
- [Testing your Coturn server](#testing-your-coturn-server)
- [Extra Credit: Why didn't this work?](#extra-credit-why-didn-t-this-work)





## Introduction

This is a quick and dirty guide on how to run STUN/TURN Coturn server using Docker.

This has some short cuts for using with Digital Ocean, but should be quite useful for running on other cloud providers.


## Get a Digital Ocean droplet running with Docker

1. Create a Digital Ocean account if nesessary
1. Log into D.O.
1. Go create an Ubuntu/Docker droplet using this DO marketplace image [https://marketplace.digitalocean.com/apps/docker](Docker on Ubuntu)
1. Log into your new droplet

## If you are not using DO, you must install Docker

Yep, if you for some reason can't use the DO docker-ready app, 
then I suggest you use Ubuntu 20.04 and install docker by hand.
[Install Docker](https://docs.docker.com/engine/install/ubuntu/)

## Log into your virtual machine

You know what to do here.


## Open a hole in the firewall on VM

```bash
sudo ufw allow 3478/udp
```

## Start Coturn with a shared secret key 

We are using the username 'user', kind of boring, huh?
The realm is really ignored in the way most people use Coturn.


```bash
docker run --name coturn -d --network=host instrumentisto/coturn \
            -n \
            --log-file=stdout \
            --fingerprint \
            --no-multicast-peers \
            --no-cli \
            --no-tls \
            --realm=foo.bar \
            --user user:ignore \
            --static-auth-secret mL0sG7iG5bB1kR2b
```

## Testing your Coturn server

I suggest you create a different nice clean blank Ubuntu 20.04 VM
to test your Coturn install.
This is kind of like using ping, but rather than the ping protocol
(ICMP) we are using the STUN/TURN protocol.


On your new VM, install Coturn without using Docker:
```bash
sudo apt -y install coturn
```

Then this command will do something like a 'ping' but using
the TURN protocol.
It will show you packet loss.
The packet loss figures tell you if things are working or not.

```bash
turnutils_uclient 161.35.2.75 -y -u user -W mL0sG7iG5bB1kR2b
```






## Extra Credit Why didn't this work?

I wanted to use docker for testing rather than installing Coturn,
but had issues using turnutils_uclient.

Not clear on the reason for failure.

```bash
# THIS WILL NOT WORK
docker run --interactive --tty --network=host --entrypoint turnutils_uclient instrumentisto/coturn 161.35.2.75 -y -u user -W mL0sG7iG5bB1kR2b
```
 



