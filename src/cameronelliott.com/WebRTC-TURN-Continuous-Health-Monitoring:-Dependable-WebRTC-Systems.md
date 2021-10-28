title: WebRTC TURN Continuous Health Monitoring: Dependable WebRTC Systems.
date: 2020-08-16
tags: WebRTC-Reliability, Stun/Turn
----

[Grafana]: https://grafana.com/grafana/
[Prometheus]: https://prometheus.io/
[Prometheus Exposition Format]: https://prometheus.io/docs/instrumenting/exposition_formats/
[CloudAlchemy]: https://github.com/cloudalchemy
[TimescaleDB]: https://www.timescale.com/
[pg_prometheus]: https://github.com/timescale/pg_prometheus
[timescale-prometheus]: https://github.com/timescale/timescale-prometheus
[Influxdb]: https://www.influxdata.com/
[Telegraf]: https://www.influxdata.com/time-series-platform/telegraf/
[RTC9.COM]: https://rtc9.com
[rtc9-turnhealthmonitor]: https://github.com/rtc9-com/rtc9-turnhealthmonitor
[Pion]: https://pion.ly/
[turn-client]: https://github.com/pion/turn/tree/master/examples
[Coturn]: https://github.com/coturn/coturn
[turnutils_uclient]: https://github.com/coturn/coturn/wiki/turnutils_uclient
[VPS]: https://en.wikipedia.org/wiki/Virtual_private_server


Table of Contents:  

* [High Level Summary for Managers and Developers](#high-level-summary-for-managers-and-developers)
  * [What is This Article About?](#what-is-this-article-about)
  * [What is TURN for WebRTC Health Monitoring?](#what-is-turn-for-webrtc-health-monitoring)
  * [Why NOT TO Monitor WebRTC TURN Server Performance &amp; Health](#why-not-to-monitor-webrtc-turn-server-performance--health)
  * [Why TO Monitor WebRTC TURN Server Performance &amp; Health](#why-to-monitor-webrtc-turn-server-performance--health)
  * [Best Health Metrics: Up/Down, Loss, Latency and Jitter](#best-health-metrics-up-down-loss-latency-and-jitter)
  * [How to Implement TURN Performance Monitoring](#how-to-implement-turn-performance-monitoring)
  * [Will Monitoring TURN Performance Get Me to Five\-Nines?](#will-monitoring-turn-performance-get-me-to-five-nines)
* [Developer How\-To for Implementing WebRTC TURN Health Monitoring](#developer-how-to-for-implementing-webrtc-turn-health-monitoring)
  * [Sample Grafana Screen Shot of Live TURN Server Monitor](#sample-grafana-screen-shot-of-live-turn-server-monitor)
  * [Critical Key Heath Metrics: Jitter, Latency, Loss](#critical-key-heath-metrics-jitter-latency-loss)
  * [Actually Measuring: Jitter, Latency, Loss](#actually-measuring-jitter-latency-loss)
  * [Monitoring Systems: Prometheus, Influxdb, TimescaleDB](#monitoring-systems-prometheus-influxdb-timescaledb)
  * [Getting Measured Metrics Into Your Monitoring System](#getting-measured-metrics-into-your-monitoring-system)
  * [Graphing with Grafana](#graphing-with-grafana)
  * [Alerting On Problematic Conditions](#alerting-on-problematic-conditions)
* [Conclusions](#conclusions)
  * [Three Ways To Get Robust Monitored STUN/TURN For WebRTC](#three-ways-to-get-robust-monitored-stun-turn-for-webrtc)
* [Explaining WebRTC STUN/TURN for the Unfamiliar](#explaining-webrtc-stun-turn-for-the-unfamiliar)
  * [What is STUN/TURN for WebRTC in a Few Sentences](#what-is-stun-turn-for-webrtc-in-a-few-sentences)
  * [TURN Services Are Needed About 15% to 20% of the Time](#turn-services-are-needed-about-15-to-20-of-the-time)





## High Level Summary for Managers and Developers

### What is This Article About?

This guide is for those using STUN/TURN with WebRTC.

It is to help you decide why you might, or why you might not monitor and track the health and performance of your STUN/TURN servers.

This will also help you decide how to implement monitoring if you decide to do it on your own.

If you need STUN/TURN monitoring, but don't want to build it yourself, [RTC9.COM] offers free and paid services.

If you choose to run your own server, and you choose to build your
own monitoring infrastructure, you can use [rtc9-turnhealthmonitor] which provides a standard HTTP Prometheus endpoint for most monitoring systems.

### What is TURN for WebRTC Health Monitoring?

Health monitoring for TURN for WebRTC provides insight into the health and performance of running STUN/TURN servers.

If you are having issues with TURN packet loss, latency, or jitter, or even
plain downtime,
it can affect WebRTC call quality, and without monitoring or insight,
if users are complaining about call quality, you will have no idea if it
is temporary packet loss, or a overloaded or malfunctioning TURN server.
Or your TURN server might just be running on an over-provisioned busy [VPS].

By monitoring some key performance metrics of your TURN servers continuously,
you can quickly identify or eliminate the TURN servers as the issue,
and proceed to get your entire WebRTC system operating at peak performance.

### Why NOT TO Monitor WebRTC TURN Server Performance & Health

During development of WebRTC systems reliability and robustness are 
usually a much lower concern than just getting applications working.
Sometimes it's just about the last concern compared to getting to market.

### Why TO Monitor WebRTC TURN Server Performance & Health

When real customers, beta-customers, management, and prospects start using
WebRTC services needing STUN/TURN, concerns about reliability can come to the front
a few different ways:

- Prospects, customers or internal teams experiencing occasional or frequent service issues.
- If representations about reliability are being made, or SLAs are being offered to WebRTC application users, questions about reliability and availability may surface even without issues having occurred.

### Best Health Metrics: Up/Down, Loss, Latency and Jitter

- Up/Down. At a minimum you really need to know if your servers are up or down, right! 
- Packet loss is a fantastic metric. Most WebRTC is over UDP, not TCP. Measuring this takes care of up/down testing.
- Latency. Latency alone won't mess with WebRTC sessions, but relative latency measurements can tell you when your TURN server is overloaded.
- Jitter. Jitter to a certain degree is not an issue, but when jitter starts to exceed certain points, de-jitter buffers on receivers will start to fail. This metric can also tell you when your server is overloaded.

### How to Implement TURN Performance Monitoring

1. If you buy fully-managed TURN services, you would hope they
are performing health monitoring comparable to what is described here.
2. You can buy TURN server health monitoring from the author's company.  
**This can take your bandwidth cost from $.50/GB to $.001/GB or lower!**  
**This is a 500 time reduction in cost!!**  
[RTC9.COM], from the author offers STUN/TURN monitoring services.
3. You can implement it using your best, most experienced in-house devops staff, based upon this guide.

### Will Monitoring TURN Performance Get Me to Five-Nines?

**NO!** TURN health monitoring alone, probably won't get you
to five-nines of reliability.  
You really need a few more things to get there, like system-wide redundancy.
Subscribe to my newsletter to get more info on achieving the highest levels of availability.


## Developer How-To for Implementing WebRTC TURN Health Monitoring

This part is not for managers, except the most curious!
This is a high-level guide to implementing TURN health monitoring.
This guide requires an experienced devops person to implement.

### Sample Grafana Screen Shot of Live TURN Server Monitor

This is an image of the continuous packet TURN session monitoring 
system we build. The first version. 
You might decide on different metrics.
This image & section is just to show what's possible, and 
does not include setup details for Grafana.

![Grafana Showing Live TURN session Data](/static/img/screenshot-from-2020-06-23-14-00-36.png)

Starting with the , this image shows:

- Lower right: The packet-count rates for TURN session testing a single TURN server with 3x monitoring systems.
- Upper right: sum of total packets lost. If these are flat, all good, if rising to right, bad.
- Lower left: This shows packet loss counters. **The interesting this here is just one monitoring VPS shows low-levels of packet loss. We are monitoring with 3x systems. We can ignore this packet loss, and not be thrown by a red-herring**
- Upper left: This shows windowed max(packet-loss) from all three 'pinger' systems. One packet may have been lost at 9am. Otherwise this looks really healthy.




### Critical Key Heath Metrics: Jitter, Latency, Loss

The three key metrics for monitoring TURN server health are: jitter, latency, and loss as mentioned in the first part of this guide.

### Actually Measuring: Jitter, Latency, Loss

You need an automated way to run TURN sessions and measure jitter, latency, and loss.

- Command-line tools:
    - The [Coturn] tool "[turnutils_uclient]" is a great tool for measuring jitter, latency, and loss from the command line.  
    - The [Pion] project also offers a "[turn-client]" command-line tool capable of running ping tests if you are looking to craft a custom solution. This is cool because it's 100% Go, and should be easily customizable.
- Prometheus-ready /metrics HTTP endpoint for continuous testing
    - [rtc9-turnhealthmonitor] is written by the author of this article. It's a project which combines [turnutils_uclient] along with a Go spawner/controller.
    This program runs frequent, but short 'ping' sessions and then parses the jitter, latency and loss metrics from the output. It then makes the metrics available using a standard Prometheus-style HTTP /metrics endpoint.  This is how I monitor TURN servers.



### Monitoring Systems: Prometheus, Influxdb, TimescaleDB

So, whether you use [rtc9-turnhealthmonitor] or cobble together your own methods to
periodically measure health metrics, you ideally want to collect those metrics for
real-time monitoring and later analysis, if needed.

The three systems below stood out to me when building a TURN health monitoring system:

1. Prometheus
    - Prometheus seems to be a leading open-source solution for metrics collection and monitoring.  In my opinion the two great contributions by Prometheus are: 1) Popularizing pull-based collection. 2) Popularizing [Prometheus Exposition Format]
2. Influxdb and Telegraf
    - [Influxdb] and [Telegraf]. Together these two form a system comparable to Prometheus. 
3. TimescaleDB
    - TimescaleDB is an adapted Postgres that supports features that make it suitable for the high-speed ingestion often associated with time-series databases. They have two open source packages built for ingesting Prometheus metric data: [pg_prometheus] and [timescale-prometheus], where the former has been sunsetted.

I currently use [Prometheus] as a system for collection and storage of metrics discussed in this article, but after having set it up, and managed it for a while, I honestly would look for
a simpler solution. Granted, I am always looking for a simpler solution!
If I had not discovered [TimescaleDB], my second choice would likely be [Influxdb].
I suspect the installation and maintenance of [Influxdb] would be simpler than [Prometheus], which I
had installed using Ansible playbooks from [CloudAlchemy].  
While everything is currently working fine, I worry about to main things:
- What to do if/when database corruption occurs
- What to do if/when the server bites it

But, ultimately, I would not replace [Prometheus] with [Influxdb], 
I would likely replace it with [TimescaleDB] and one of the packages mentioned for ingesting
Prometheus metric data.

These topics are worth an article in itself, please write me if this interests you,
and/or join my mailing list.



### Getting Measured Metrics Into Your Monitoring System

So, once you have chosen a tool to periodically measure current jitter, latency, and loss,
and you have chosen a metrics database and monitoring system, you actually need to get
the metrics into the database.

If you chose [Prometheus] for your monitoring system,
[rtc9-turnhealthmonitor] provides it's metrics in Prometheus format,
and it is standard straight forward work to wire the two together so your
metrics end up in Prometheus.

If you chose [Influxdb] and [Telegraf] for your monitoring system, 
Telegraf will poll and ingest metrics into Influxdb from standard Prometheus HTTP
endpoints. Get [rtc9-turnhealthmonitor] working, and start polling it with Telegraf.  
The [Prometheus poller for Telegraf is described here][xxx1].

[xxx1]: https://www.influxdata.com/integration/prometheus-monitoring-tool/

If you chose [TimescaleDB] for your metrics data store, you probably need to be using 
[timescale-prometheus] for metrics collection and ingest. 
Which will simply use Prometheus for metrics collection.
Even thought it is sunsetted, I personally like the simplicity of [pg_prometheus],
but I wouldn't recommend that route unless you are very experienced or a brave soul or
both.  if I get some more experience with [timescale-prometheus],
I'll write about it, and share to my newletter list.

At [RTC9.com], if we use TimescaleDB for metric storage, we likely won't use Prometheus for metric collection, we might look for a simpler route.  If you look at the help docs in [pg_prometheus], 
a single bash command-line example shows how `curl` can be used to pull and insert metrics
into the database. 



### Graphing with Grafana

At RTC9 we use [Grafana] for graphing and monitoring the jitter, latency, and loss of TURN sessions metrics collected. [Grafana] is cool in that it supports alerting in addition to graphing and analysis.

There is not much more to say about Grafana here, it seems to be the most popular open-source
package for graphing and looking at real-time monitoring metrics.

### Alerting On Problematic Conditions

It can take a bit of time to figure out what the right thresholds are for alerting on.
While we use bare metal for our TURN server, we use VPSs for our TURN polling servers.
Because these are subject to a wide performance range, due to the nature of VPSs,
it took us a while to figure how the best trade-off between alerting too-soon, vs. waiting-too-long
for metric ranges to be considered alertable.

## Conclusions

If you are in the development phase of your WebRTC STUN/TURN effort,
and running your own TURN server, TURN health monitoring might be overkill,
but you may want to consider your plan for when you go production.

If you have prospects, customers, management using your WebRTC applications,
and you are running TURN servers without any kind or inside performance-metrics
visibility, you might ask, what are you going to do if & when people
say they had a problem with a call.
Being able to research problem reports and proactively fix performance issues makes the difference between systems that are a nightmare and those that a devops person can be proud to run.





### Three Ways To Get Robust Monitored STUN/TURN For WebRTC

1. Buy Fully Managed STUN/TURN services. (hopefully your vendor monitors jittery, latency, loss)
2. Run your own TURN servers and buy health monitoring services. Visit [RTC9.COM]
3. Build your own monitoring infrastructure as per this article.


## Explaining WebRTC STUN/TURN for the Unfamiliar

### What is STUN/TURN for WebRTC in a Few Sentences

STUN and TURN are services, often used in WebRTC, that help endpoints do the following:

- STUN: STUN servers allow endpoints to discover their IP address on the Internet. 
- TURN: TURN servers allow endpoints behind firewalls that are unable to directly exchange data, to exchange data through the TURN server.
- STUN and TURN generally are offered through the same program on the same server.

### TURN Services Are Needed About 15% to 20% of the Time

It is generally reported that for a large set of connections between peers
that TURN relay services are needed about 15% to 20% of the time.
Some scenarios should rarely need TURN, if ever, for example non-firewalled non-NATted hosts
in WebRTC sessions.
