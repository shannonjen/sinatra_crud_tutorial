# Sinatra/Rack/ActiveRecord/sqlite3 App: Simple Steps

"<a href="http://www.sinatrarb.com/intro.html">Sinatra</a> is a DSL for quickly creating web applications in Ruby with minimal effort"

"<a href="https://rubygems.org/gems/rack">Rack</a>provides a minimal, modular and adaptable interface for developing web applications in Ruby. By wrapping HTTP requests and responses in the simplest way possible, it unifies and distills the API for web servers, web frameworks, and software in between (the so-called middleware) into a single method call."

"<a href="http://guides.rubyonrails.org/active_record_basics.html">Active Record</a> is the M in MVC - the model - which is the layer of the system responsible for representing business data and logic. Active Record facilitates the creation and use of business objects whose data requires persistent storage to a database."

## Part One: Setting Up

1.) Create project directory

`$ mkdir building_sinatra_blog_app`


2.) Add a Gemfile (no file extension) that includes the gems needed for you application. This file is used by the Bundler gem.

`#Gemfile`
`source "http://rubygems.org"`
``
`gem "activerecord"`
`gem "sinatra-activerecord"`
`gem "rake"`
`gem "sqlite3"`


3.) Install the gems. This generates the Gemfile.lock file. 

`$ bundle install`


4.) Create the main application file (app.rb) and require in the gems (the ruby libraries) that will be used in this file and set/name the database. Notice the syntax of the second argument of the set method.

`# app.rb`
`require "sinatra"`
`require "sinatra/activerecord"`
``
`set :database, "sqlite3:myblogdb.sqlite3"`


5.) Create a Rakefile (no file extension). This file locates and loads tasks that can be run from the command line. It allows us to use migrations to set up the data model. 

`#Rakefile`
``
`require "./app"`
`require "sinatra/activerecord/rake"`


6.) Use command line rake task to create the database

`$ rake db:create`


### Part One Recap
At this point, we have installed the necessary gems for Rake, ActiveRecord and sqlite3, created the main application file, set the database, and created a Rakefile which has allowed us to use a command line rake task to create the database.

The app we want to build is a basic blog that allows a user to add a post with a title and a body. We can create a database table called posts that has three columns: a string column called title, a text column called body, and a timestamps column (which gives us two automatic datetime columns called created_at and updated_at). We'll model the posts with an Active Record model class called Post. 






