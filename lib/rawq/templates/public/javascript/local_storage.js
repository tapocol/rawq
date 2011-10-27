function LocalStorage(storage_engine) {
  this.storage_engine = storage_engine;
}

LocalStorage.prototype.set = function(key, value) {
  this.storage_engine.setItem(key, LocalStorage.encode(value));
};

LocalStorage.prototype.get = function(key) {
  return LocalStorage.decode(this.storage_engine.getItem(key));
};

LocalStorage.encode = function(value) {
  return JSON.stringify(value);
};

LocalStorage.decode = function(value) {
  return JSON.parse(value);
};

