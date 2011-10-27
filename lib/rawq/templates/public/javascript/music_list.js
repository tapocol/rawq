function MusicList(element) {
  this.element = element;
}

MusicList.prototype.render = function(rawq) {
  var media_list = rawq.storage.get("media_list");
  for (var i = 0; i < media_list.length; i++) {
    var media = rawq.storage.get("media_" + media_list[i]);
    var item_element = $(rawq.view.render("music_list_item.ejs", {media_id: media_list[i], media: media}));
    item_element.click(function() {
      rawq.handle_media_click.call(rawq, $(this).attr("id"));
    });
    this.element.append(item_element);
  }
}

