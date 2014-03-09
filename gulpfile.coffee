gulp = require 'gulp'
gutil = require 'gulp-util'
watch = require 'gulp-watch'
plumber = require 'gulp-plumber'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
jade = require 'gulp-jade'
clean = require 'gulp-clean'

server = require './server'
skills = require './src/content/skills'
social = require './src/content/social'

# buildIndex = require ''

# Dev

buildDevIndex = ->
  # gulp.src('src/index.hbs')
  #   .pipe(buildIndex.dev(config.scripts, ['stylesheets/all.css']))
  #   .pipe(gulp.dest('./_dev/'))

gulp.task 'watchCoffee', ->
  watchCoffee = watch glob: 'src/scripts/**/*.coffee'
  watchCoffee
    .pipe(plumber())
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('./_dev/scripts/'))

  watchCoffee.gaze.on 'all', (event)->
    # buildDevIndex()

gulp.task 'watchSass', ->
  watch glob: 'src/stylesheets/*.scss', ->
    gulp.src('src/stylesheets/!(_)*.scss')
      .pipe(plumber())
      .pipe(sass())
      .pipe(gulp.dest('./_dev/stylesheets/'))

gulp.task 'watchCopies', ->
  watch(glob: 'src/images/**/*')
    .pipe(gulp.dest('./_dev/images/'))
  watch(glob: 'src/scripts/lib/*')
    .pipe(gulp.dest('./_dev/scripts/lib/'))

gulp.task 'watchIndex', ->
  jadeOptions =
    locals:
      skills: skills
      social: social
    pretty: true

  watch(glob: 'src/index.jade')
    .pipe(plumber())
    .pipe(jade(jadeOptions))
    .pipe(gulp.dest('./_dev/'))

gulp.task 'watch', ['watchCoffee', 'watchSass', 'watchCopies', 'watchIndex']

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