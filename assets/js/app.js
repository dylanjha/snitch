// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "bootstrap"
import css from "../css/app.scss"
import "phoenix_html"

import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live")
liveSocket.connect()

const initializeHlsVideo = () => {
  const video = document.getElementById('mux-playback');
  const hlsSrc = (video ? video.getAttribute('data-hls-src') : null);
  const alreadyInitialized = (video ? video.getAttribute('hls-initialized') : null);
  if (video && hlsSrc && !alreadyInitialized) {
    video.setAttribute('hls-initialized', true);
    const hls = new Hls();
    hls.loadSource(hlsSrc);
    hls.attachMedia(video);
    hls.on(Hls.Events.MANIFEST_PARSED, function () {
      video.play().catch((err) => console.error('Error attempting autoplay', err));
    });
  }
}

document.addEventListener("phx:update", initializeHlsVideo);

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
