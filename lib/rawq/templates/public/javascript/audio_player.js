function AudioPlayer(options) {
  this.options = $.extend({
    selector: "#audio-player"
  }, options);
  this.element = $(this.options.selector)
}

AudioPlayer.prototype.change = function(audio) {
  this.element.html(window.rawq.view.render("audio_sources.ejs", {sources: audio.sources}));
};

