require 'bundler'
Bundler.require

DB = ActiveRecord::Base.establish_connection({
    adapter: 'sqlite3',
    database: 'db/recipes.db'
})

require_all 'lib'
