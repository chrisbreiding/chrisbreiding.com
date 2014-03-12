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
glob = require 'glob'
server = require './server'


# Dev

cssFiles = ->
  files = glob.sync('_dev/stylesheets/*.css').map (file)->
    file.replace '_dev', ''
  # ensure all is last
  files.sort (a, b)->
    a.indexOf('all.css') - b.indexOf('all.css')

jsFiles = ->
  files = glob.sync('_dev/scripts/**/*.js').map (file)->
    file.replace '_dev', ''
  # ensure jquery is first
  files.sort (a, b)->
    b.indexOf('jquery.js') - a.indexOf('jquery.js')

buildDevIndex = ->
  jadeOptions =
    locals:
      stylesheets: cssFiles()
      scripts: jsFiles()
      social: require './src/content/social'
      projects: require './src/content/projects'
      skills: require './src/content/skills'
    pretty: true

  gulp.src('src/index.jade')
    .pipe(plumber())
    .pipe(jade(jadeOptions))
    .pipe(gulp.dest('./_dev/'))

gulp.task 'watchCoffee', ->
  watch glob: 'src/scripts/**/*.coffee', (files)->
    files
      .pipe(plumber())
      .pipe(coffee().on('error', gutil.log))
      .pipe(gulp.dest('./_dev/scripts/'))
    buildDevIndex()

gulp.task 'watchSass', ->
  watch glob: 'src/stylesheets/*.scss', ->
    gulp.src('src/stylesheets/!(_)*.scss')
      .pipe(plumber())
      .pipe(sass())
      .pipe(prefix('last 3 versions', 'ie 8'))
      .pipe(gulp.dest('./_dev/stylesheets/'))
    buildDevIndex()

gulp.task 'watchImages', ->
  imageCategories = ['contact', 'projects', 'skills', 'social']
  for imageCategory in imageCategories
    do (imageCategory)->
      watch glob: "src/images/#{imageCategory}/*.png", ->
        spriteData = gulp.src("src/images/#{imageCategory}/*.png")
          .pipe spritesmith
            imgName: "../images/#{imageCategory}.png"
            cssName: "#{imageCategory}.css"
        spriteData.img.pipe(gulp.dest('_dev/images/'))
        spriteData.css.pipe(gulp.dest('_dev/stylesheets/'))
        buildDevIndex()

gulp.task 'watchCopies', ->
  watch(glob: 'src/images/*.+(png|gif|jpg|ico)').pipe(gulp.dest('./_dev/images/'))
  watch(glob: 'src/scripts/lib/*').pipe(gulp.dest('./_dev/scripts/lib/'))

gulp.task 'watchIndex', ->
  watch glob: 'src/index.jade', buildDevIndex
  watch glob: 'src/content/*.json', buildDevIndex

gulp.task 'watch', ['watchCoffee', 'watchSass', 'watchImages', 'watchCopies', 'watchIndex']

gulp.task 'devServer', -> server '_dev', 8080

gulp.task 'dev', ['watch', 'devServer']


# Prod

gulp.task 'prod', ->


# Deploy

gulp.task 'deploy', ->


# Misc

gulp.task 'cleanBuild', ->
  gulp.src('_build', read: false).pipe(clean())

gulp.task 'cleanDev', ->
  gulp.src('_dev', read: false).pipe(clean())

gulp.task 'clean', ['cleanBuild', 'cleanDev']
