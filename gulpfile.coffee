for filename in require('fs').readdirSync "#{__dirname}/script/tasks"
  require "#{__dirname}/script/tasks/#{filename}"
