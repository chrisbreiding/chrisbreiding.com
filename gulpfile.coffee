fs = require 'fs'
gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
plumber = require 'gulp-plumber'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
prefix = require 'gulp-autoprefixer'
jade = require 'gulp-jade'
spritesmith = require 'gulp.spritesmith'
clean = require 'gulp-clean'
uglify = require 'gulp-uglify'
minifyCss = require 'gulp-minify-css'
order = require 'gulp-order'
es = require 'event-stream'
concat = require 'gulp-concat'
server = require './server'
deploy = require './lib/deploy'


getJSON = (name)->
  JSON.parse fs.readFileSync "#{__dirname}/src/content/#{name}.json"

buildIndex = (cssFiles, jsFiles, destination)->
  jadeOptions =
    locals:
      stylesheets: cssFiles
      scripts: jsFiles
      social: getJSON 'social'
      projects: getJSON 'projects'
      skills: getJSON 'skills'
    pretty: true

  gulp.src('src/index.jade')
    .pipe(plumber())
    .pipe(jade(jadeOptions))
    .pipe(gulp.dest("./#{destination}/"))

imageCategories = ['header', 'projects', 'skills', 'contact']

spriteAndCopyImages = (imageCategory, destination)->
  spriteData = gulp.src("src/images/#{imageCategory}/*.png")
    .pipe spritesmith
      imgName: "../images/#{imageCategory}.png"
      cssName: "_#{imageCategory}.scss"
      cssFormat: 'scss'
  spriteData.img.pipe(gulp.dest("#{destination}/images/"))
  spriteData

# Dev

buildDevIndex = ->
  jsFiles = [
    "scripts/lib/jquery.js"
    "scripts/scripts.js"
  ]
  buildIndex ['stylesheets/all.css'], jsFiles, '_dev'

gulp.task 'watchCoffee', ->
  watch glob: 'src/scripts/**/*.coffee', (files)->
    files
      .pipe(plumber())
      .pipe(coffee().on('error', gutil.log))
      .pipe(gulp.dest('./_dev/scripts/'))
    buildDevIndex()

gulp.task 'watchImages', ->
  for imageCategory in imageCategories
    do (imageCategory)->
      watch glob: "src/images/#{imageCategory}/*.png", ->
        spriteData = spriteAndCopyImages imageCategory, '_dev'
        spriteData.css.pipe(gulp.dest('src/stylesheets/generated/'))
        buildDevIndex()

gulp.task 'watchSass', ['watchImages'], ->
  watch glob: 'src/stylesheets/*.scss', ->
    gulp.src('src/stylesheets/!(_)*.scss')
      .pipe(plumber())
      .pipe(sass())
      .pipe(prefix('last 3 versions', 'ie 8'))
      .pipe(gulp.dest('./_dev/stylesheets/'))
    buildDevIndex()

gulp.task 'watchCopies', ->
  watch(glob: 'src/images/*.+(png|gif|jpg|ico)').pipe(gulp.dest('./_dev/images/'))
  watch(glob: 'src/scripts/lib/*').pipe(gulp.dest('./_dev/scripts/lib/'))

gulp.task 'watchIndex', ['watchCoffee', 'watchSass', 'watchCopies'], ->
  watch glob: 'src/index.jade', buildDevIndex
  watch glob: 'src/content/*.json', buildDevIndex

gulp.task 'devServer', -> server '_dev', 8080

gulp.task 'dev', ['watchIndex', 'devServer']


# Prod

cacheBuster = ''

gulp.task 'buildCopy', ['cleanBuild'], ->
  gulp.src('src/images/*.+(png|gif|jpg|ico)').pipe(gulp.dest('./_build/images/'))
  gulp.src('CNAME').pipe(gulp.dest('./_build/'))

gulp.task 'buildJs', ['buildCopy'], ->
  cacheBuster = (new Date()).valueOf()

  coffeeJs = gulp.src('src/scripts/*.coffee').pipe(coffee().on('error', gutil.log))
  libJs = gulp.src('src/scripts/lib/*.js')

  es.merge(coffeeJs, libJs)
    .pipe(order([
      'src/scripts/lib/jquery.js'
      'src/scripts/**/*.js'
    ]))
    .pipe(uglify())
    .pipe(concat("all-#{cacheBuster}.js"))
    .pipe(gulp.dest('./_build/scripts/'))

gulp.task 'buildSass', ['buildJs'], ->
  spriteCss = for imageCategory in imageCategories
    spriteAndCopyImages(imageCategory, '_build').css
  sassCss = gulp.src('src/stylesheets/!(_)*.scss').pipe(sass())

  es.merge(sassCss, es.merge(spriteCss...))
    .pipe(minifyCss())
    .pipe(concat("all-#{cacheBuster}.css"))
    .pipe(gulp.dest('./_build/stylesheets/'))

gulp.task 'build', ['buildCopy', 'buildSass'], ->
  buildIndex ["stylesheets/all-#{cacheBuster}.css"], ["scripts/all-#{cacheBuster}.js"], '_build'

gulp.task 'prod', ['build'], ->
  server '_build', 8081


# Deploy

gulp.task 'deploy', ['build'], ->
  deploy()


# Misc

gulp.task 'cleanBuild', ->
  gulp.src('_build', read: false).pipe(clean())

gulp.task 'cleanDev', ->
  gulp.src('_dev', read: false).pipe(clean())
  gulp.src('src/stylesheets/generated', read: false).pipe(clean())

gulp.task 'clean', ['cleanBuild', 'cleanDev']
