function Rawq(options) {
  var defaults = {
    media_players: $("#media_players"),
    audio_player: new AudioPlayer({selector: "#audio_player"}),
    media_lists: $("#media_lists"),
    music_list: new MusicList($("#music_list")),
    view: new View(),
    storage: new LocalStorage(window.localStorage)
  };
  options = $.extend(defaults, options);
  for (var key in options) {
    this[key] = options[key];
  }
}

Rawq.prototype.download_media = function(callback) {
  var _this = this;
  $.getJSON("/media", function(data) {
    _this.store_media(data);
    callback.call();
  });
};

Rawq.prototype.store_media = function(data) {
  var media_list_data = [];
  for (var i = 0; i < data.length; i++) {
    media_list_data.push(data[i]._id);
    this.store_sources_data(data[i]._id, data[i].sources);
    this.storage.set("media_" + data[i]._id, { name: data[i].name });
  }
  this.storage.set("media_list", media_list_data);
};

Rawq.prototype.store_sources_data = function(media_id, sources) {
  var sources_data = [];
  for (var i = 0; i < sources.length; i++) {
    sources_data[i] = {
      src: Rawq.get_source_url(media_id, sources[i]._id),
      mimetype: sources[i].mimetype
    };
  }
  this.storage.set("media_" + media_id + "_sources", sources_data);
};

Rawq.prototype.render_music_list = function() {
  this.music_list.render(rawq);
};

Rawq.prototype.handle_media_click = function(media_id) {
  this.audio_player.change(this.view, {
    sources: this.storage.get("media_" + media_id + "_sources")
  });
};

Rawq.get_source_url = function(media_id, source_id) {
  return "/media/" + media_id + "/" + source_id;
};

