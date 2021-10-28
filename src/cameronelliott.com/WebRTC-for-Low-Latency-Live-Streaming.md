title: WebRTC for Low Latency Live Streaming: Many Choices
date: 2020-08-08
tags: WebRTC-Live-Streaming
----


* [Introduction](#introduction)
* [Different Methods of Implementing Low Latency WebRTC Live Streaming](#different-methods-of-implementing-low-latency-webrtc-live-streaming)
  * [Cloud/Saas Services for WebRTC Live Streaming](#cloud-saas-services-for-webrtc-live-streaming)
  * [On\-Premise for Your Servers](#on-premise-for-your-servers)
  * [Open Source Software for WebRTC Live Streaming](#open-source-software-for-webrtc-live-streaming)
  * [Low\-latency Live Streaming Without Using WebRTC](#low-latency-live-streaming-without-using-webrtc)
  * [Low\-latency Live Streaming with WebRTC Data Channels, not Media Channels](#low-latency-live-streaming-with-webrtc-data-channels-not-media-channels)


[HLS]: https://en.wikipedia.org/wiki/HTTP_Live_Streaming
[DASH]: https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP

## Introduction

Digital video is ubiquitous these days, it's everywhere. But the primary technology used for the digital video distribution is HTTP segment-based adaptive streaming. This is the basic framework around which technologies like [DASH] and [HLS] work.

Segment based adaptive steaming is great for reuse of current HTTP tools and HTTP based CDN platforms. But the nature of retrieving segments or chunks from sources or CDNs means that your source to playback latency is usually a minimum of your segment duration, easily 30 seconds end-to-end.

Why isn't this good enough?

This is problematic, because segment-based technologies struggle to achieve latency under 10 seconds, some vendors say their highly tuned stacks can achieve two seconds. But don't think this easy is going to be easy. Segment based video just wasn't designed for low latency.

The claims on latency for WebRTC latency vary between 200ms and 500ms. Keep in mind ping time between NYC and Los Angeles is just under 70ms, and front end ingest can play a big part in total latency.

There are a ton of applications where sub-second latency can enhance or even make or break the viability of the application.

Some application examples:

- Remote movie editing and post-production 
- eSports and video game playing
- Security and defense video monitoring 
- Remote medical inspection and operating
- Live sports event broadcasting 

Below we explore some of the different way you can implement WebRTC Live Streaming.
included are some of the different offerings and vendors that can help. The lists below are not exhaustive, but represent some popular and visible choices.

<br>

## Different Methods of Implementing Low Latency WebRTC Live Streaming

### Cloud/Saas Services for WebRTC Live Streaming

These cloud solutions offer a quick way to get up and running with low-latency live streaming based upon WebRTC.

[Millicast](https://millicast.com/)
</br>
Millicast bills themselves as a `Realtime CDN built for large-scale video broadcasting on any device, with sub-second latency`.  The teams behind Millicast have a very WebRTC centric background including TURN services, and research in WebRTC. My take on Millicast is that it is a WebRTC-first offering built specifically for WebRTC.

[Red5Pro](https://www.red5pro.com/)
</br>
Red5Pro describes their service as `Low Latency WebRTC Live Video Streaming at Scale`. According to their site, the Red5Pro server started around 2005 by reverse engineering RTMP. On github, the red5-server repo has releases as far back as 2014. So, Red5Pro was not built around WebRTC as Millicast has been. Their are pros and cons to this.  Red5Pro might offer more delivery mechanisms than the WebRTC-first offerings.

[Limelight CDN Realtime Streaming](https://www.limelight.com/realtime-streaming/)
</br>
Limelight Realtime Streaming is a WebRTC based solution, according to some built on the Red5Pro server.


[The Vonage Video API (formerly TokBox OpenTok)](https://www.vonage.com/communications-apis/video/)
</br>
Tokbox was aquired by Vonage, which now offers `The Vonage Video API`. `The Video API makes it easy to build a custom video experience for  mobile, web, or desktop`.

[LiveSwitch Cloud](https://www.liveswitch.io/)
`Stream live video on all browsers, devices, and hardware.` is how LiveSwitch introduces their offering.


[Wowza](https://www.wowza.com/low-latency/webrtc-streaming-software) 
</br>
Wowza, a long time leader in traditional adaptive streaming, does says their service `allows you to stream WebRTC end-to-end`.  


### On-Premise for Your Servers

These solutions get installed on your cloud servers, or bare metal if you go that route.

[Red5Pro](https://www.red5pro.com/)
</br>
In addition to offering a cloud/SaaS service, Red5Pro offers installable software.


[Ant Media Server](https://antmedia.io/)
</br>
According to Ant Media, they offer `Scalable, Ultra Low Latency & Adaptive WebRTC Streaming`


[Wowza](https://www.wowza.com/low-latency/webrtc-streaming-software) 
</br>
Wowza offers on-premise installable software in addition to their cloud offering.


### Open Source Software for WebRTC Live Streaming

These solutions generally require developer time to reach your desired goal, but can offer more flexibility than the usual installable software or cloud solutions depending on your needs.

[Pion](https://pion.ly/)
</br>
Pion has rapidly attracted a following as a Go language WebRTC implementation. There are SFU examples for live streaming inside the Pion repos, and also some [3rd party examples](https://github.com/pion/awesome-pion).

[Janus](https://janus.conf.meetecho.com/) 
</br>
Janus' site says: `the general purpose WebRTC server`.
It's implemented in C++ and some examples use gStreamer. GPL licensed. 
[A streaming test](https://janus.conf.meetecho.com/streamingtest.html) example is available
from their site, and in the source code. I personally have more experience with Janus than the other popular media servers. I really liked the fact they had an online example of an SFU.

[Jitsi](https://jitsi.org/) From their site: `Jitsi is a set of open-source projects that allows you to easily build and deploy secure videoconferencing solutions. We are best known for our Jitsi Meet video conferencing platform, meet.jit.si where we host a Jitsi Meet instance that the community can use for totally free video conferences , and the Jitsi Videobridge that powers all of our multi-party video capabilities.`

[Kurento](https://www.kurento.org/) They say: `Kurento is a WebRTC media server and a set of client APIs making simple the development of advanced video applications for WWW and smartphone platforms.`
One of Kurento's nest features is the ability to use OpenCV in a plug and play manner. Computer vision, speech analysis and similar media analysis seems to be a differentiator for Kurento.

[Mediasoup](https://mediasoup.org/) 
</br>
`Cutting Edge WebRTC Video Conferencing` per their site.
What kind of sets Mediasoup apart is the fact is it a Node.js module and installed via [NPM](https://en.wikipedia.org/wiki/Npm_(software))




### Low-latency Live Streaming Without Using WebRTC


[Streaming Global](https://www.streamingglobal.com/)
While WebRTC is becoming a popular way to deliver low latency video to the browser, it is not the only way. Streaming Global is an interesting company that does not use WebRTC for delivery. This can have it's pros and cons.


### Low-latency Live Streaming with WebRTC Data Channels, not Media Channels

Finally, it's worth mentioning this unusual approach.  Doing TCP sockets from the browser is old hat, and there are lots of examples of sites and applications doing AJAX and TCP directly to get media into the browser.  But there are not really examples of UDP applications, because UDP connectivity is not supported directly browsers. But WebRTC Data Channels can give browser applications UDP-like latency and datagram-style connectivity. There are rumours of companies using WebRTC Data Channels for media transfer and then rendering audio and video media directly.


 



