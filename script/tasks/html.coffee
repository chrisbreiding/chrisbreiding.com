fs = require 'fs'
gulp = require 'gulp'
handlebars = require 'gulp-compile-handlebars'
rename = require 'gulp-rename'

scripts = require './scripts'
stylesheets = require './stylesheets'
statics = require './static'

buildIndex = (destination, data)->
  gulp.src('src/index.hbs')
    .pipe handlebars(data)
    .pipe rename('index.html')
    .pipe gulp.dest("./#{destination}/")

manifests = [
  { type: 'stylesheets', array: true,  file: 'app.css' }
  { type: 'favicon',     array: false, file: 'favicon.ico' }
  { type: 'scripts',     array: true,  file: 'app.js' }
]

gulp.task 'build-index', ['build-scripts', 'build-stylesheets', 'build-static'], ->
  data = {}

  for manifest in manifests
    file = "./_prod/#{manifest.type}-manifest.json"
    name = JSON.parse(fs.readFileSync(file))[manifest.file]
    data[manifest.type] = if manifest.array then [name] else name
    fs.unlinkSync file

  buildIndex '_prod', data

gulp.task 'build-dev-index', ->
  buildIndex '_dev',
    stylesheets: stylesheets.files
    scripts: scripts.files
    favicon: statics.favicon

gulp.task 'watch-index', ['build-dev-index'], ->
  gulp.watch 'src/index.hbs', ['build-dev-index']
