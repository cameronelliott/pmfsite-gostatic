# WebRTC SFU Room Video Switching Methods

Q4 2021 Cameron Elliott

## Background

When implmenting multi-room SFUs where subscribers receive an audio
and video track, it's often desirable to allow subs to 
switch between the rooms in realtime.
While the usually doesn't present a problem for audio,
it can present difficulties for video.

In all cases below, it is presumed RTP timestamp and sequence number
continuity will be presumed.

It is also presumed that SFU video input will regularly have keyframes
in the video elementary stream (ES).
The period of the keyframes not fixed, but might be between 3 and 30 seconds,
for example.

## Method: Dumb Video Switching

In this case elementary streams will just be cut when a switch is
requested. The can and will usually cause glitches, as the incoming ES is probably
not on a keyframe boundary.

## Method: Wait for Keyframe

In this case the SFU will not effect the switch until a keyframe arrives in
the new-stream. This means the switch can be delayed upto the keyframe-period.
This is kind of ugly from a users perspective, as they might request room-X, but
it will on average take keyframe-period/2 time before the switch occurs.

## Method: Generate Keyframe on Switch Request

This is beautiful, as a keyframe as generated right when a switch is requested,
on the incoming stream. The issue here is the is difficult to implement and
presents a new contstraint on SFU capacity. Depending on the implementation,
SFU capacity may depend on switching frequency and stream resolutions.
It seems fairly problematic from this perspective.

## Method: Replay from Last Keyframe / Keep New Latency 

The SFU can immediately start packets from the incoming stream, at the last keyframe presented.  This has the effect to the user
of looking like an instant switch.  The issue is you have now
introduced a buffer and latency time equal to the delay between when
the last keyframe was received and when it is sent to the subscriber.
If designers are not concerned about latency, this isn't an issue.
But in that case, why use WebRTC?

## Method: Replay from Last Keyframe / Cut on Next Keyframe

Like the last method, the cut happens instantly, replaying from the last
keyframe, but rather than maintaining the new delay between RX and TX,
when the next keyframe is received on RX, another switch is made, to
real-time forwarding of packages between RX and TX.
This means the viewer will see a scene cut of on average keyframe-period/2
in their video stream.
*Nonetheless* this seems to me like the ideal way to implement instant
room switching without introducting big latency periods into the
receivers video stream.




