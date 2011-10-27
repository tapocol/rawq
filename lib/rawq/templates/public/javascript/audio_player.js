function AudioPlayer(options) {
  this.options = $.extend({
    selector: "#audio-player"
  }, options);
  this.element = $(this.options.selector)
}

AudioPlayer.prototype.change = function(view, audio) {
  this.element.html(view.render("audio_sources.ejs", {sources: audio.sources}));
};

