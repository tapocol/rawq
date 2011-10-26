function View() {
  this.dir = "/templates";
}

View.prototype.render = function(file, vars) {
  return new EJS({url: this.full_path(file)}).render(vars);
};

View.prototype.full_path = function(file) {
  return this.dir + "/" + file;
};

