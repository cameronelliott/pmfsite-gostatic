


- [Browser Camera use from HTTPS vs HTTP](#browser-camera-use-from-https-vs-http)
  - [What is Happening, on "Camera NOT available!" page:](#what-is-happening-on-camera-not-available-page)
  - [What MDN Says](#what-mdn-says)


## Browser Camera use from HTTPS vs HTTP

The short story is that browsers will not let JS code access the 
camera device from pages loaded using HTTP.
There is one exception to this, if you are using 'localhost' as 
the server name.

### What is Happening, on "Camera NOT available!" page:

- In short, this page, is like a camera source, so you can test on HTTP to get started!
- You're probably on HTTP, not HTTPS, so, there is no camera available.
- The "Camera NOT available!" is an MP4 embedded into deadsfu
- The browser code uses this MP4 as an input source into the browser WebRTC PeerConnection.
- This video clip is replacing the camera, since you are on HTTP
- The video media is being sent via WebRTC/SRTP to the SFU
- You can connect to the room and see this WebRTC video stream

### What MDN Says

From this page:  
https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia#privacy_and_security

> getUserMedia() is a powerful feature which can only be used in secure contexts; in insecure contexts, navigator.mediaDevices is undefined, preventing access to getUserMedia(). A secure context is, in short, a page loaded using HTTPS or the file:/// URL scheme, or a page loaded from localhost.



