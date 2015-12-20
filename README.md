# Sinatra/ActiveRecord/sqlite3 App: Simple Steps

"<a href="http://www.sinatrarb.com/intro.html">Sinatra</a> is a DSL for quickly creating web applications in Ruby with minimal effort"

"<a href="https://github.com/janko-m/sinatra-activerecord">Sinatra ActiveRecord Extension</a> extends Sinatra with extension methods and Rake tasks for dealing with an SQL database using the ActiveRecord ORM."

"<a href="http://guides.rubyonrails.org/active_record_basics.html">Active Record</a> is the M in MVC - the model - which is the layer of the system responsible for representing business data and logic. Active Record facilitates the creation and use of business objects whose data requires persistent storage to a database."

## Part One: Setting Up

1.) Create project directory

```bash
mkdir building_sinatra_blog_app
```

2.) Add a Gemfile (no file extension) that includes the gems needed for you application. This file is used by the Bundler gem.

```ruby
#Gemfile
source "http://rubygems.org"

gem "activerecord"
gem "sinatra-activerecord"
gem "rake"
gem "sqlite3"
```

3.) Install the gems. This generates the Gemfile.lock file. 

```bash
bundle install
```

4.) Create the main application file (app.rb) and require in the gems (the ruby libraries) that will be used in this file and set/name the database. Notice the syntax of the second argument of the set method. 

```ruby
# app.rb
require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:myblogdb.sqlite3"
```

5.) Create a Rakefile (no file extension). This file locates and loads tasks that can be run from the command line.

```ruby
#Rakefile

require "./app"
require "sinatra/activerecord/rake"
```

6.) Use command line rake task to create the database

```bash
rake db:create
```

### Part One Recap
At this point, we have installed the necessary gems for Rake, ActiveRecord and sqlite3, created the main application file, set the database, and created a Rakefile which has allowed us to use a command line rake task to create the database.

The app we want to build is a basic blog that allows a user to add a post with a title and a body. We can create a database table called posts that has three columns: a string column called title, a text column called body, and a timestamps column (which gives us two automatic datetime columns called created_at and updated_at). We'll model the posts with an Active Record model class called Post. 

## Part Two: Model

We will do two things in this step: add a posts table to the empty database and create a class called Post (an Active Record model), mapped to the posts table. This will allow us to make queries on the posts table using Active Record methods. 

ex.
```ruby
@post = Post.find(2)
```

You can read more about Object-Relational Mapping (ORM) and Active Record <a href="http://guides.rubyonrails.org/active_record_basics.html">here</a>. 

1.) Use command line rake task to create a migration with the name parameter set to create_posts. You can get a list of the rake tasks by typing the rake command with a -T flag. 

```bash
$ bundle exec rake -T
rake db:create              # Creates the database from DATABASE_URL or con...
rake db:create_migration    # Create a migration (parameters: NAME, VERSION)
rake db:drop                # Drops the database from DATABASE_URL or confi...
rake db:fixtures:load       # Load fixtures into the current environment's ...
rake db:migrate             # Migrate the database (options: VERSION=x, VER...
rake db:migrate:status      # Display status of migrations
rake db:rollback            # Rolls the schema back to the previous version...
rake db:schema:cache:clear  # Clear a db/schema_cache.dump file
rake db:schema:cache:dump   # Create a db/schema_cache.dump file
rake db:schema:dump         # Create a db/schema.rb file that is portable a...
rake db:schema:load         # Load a schema.rb file into the database
rake db:seed                # Load the seed data from db/seeds.rb
rake db:setup               # Create the database, load the schema, and ini...
rake db:structure:dump      # Dump the database structure to db/structure.sql
rake db:structure:load      # Recreate the databases from the structure.sql...
rake db:version             # Retrieves the current schema version number
```

```ruby
$ rake db:create_migration NAME=create_posts
```

The name of the migration file is the name passed in as NAME via the db:create_migration rake command and is preceded by a timestamp. The migration file is a ruby script. The file itself is found in the newly created (because this was the first migration) db directory.


2.) To the change method, add a block that creates a  posts table with the desired columns. 

```ruby
class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts do |t|
        t.string :title
        t.text :body
        t.timestamps null: false
    end
  end
end
```

This change method will get called when the migration is run.

3.) Use the command line rake task to run the migration.

```bash
$ rake db:migrate
```

Because this is our first migration, the db/schema.rb file is generated. The db/schema.rb should not be altered. This file represents the up to date structure of your database and is maintained by Active Record. You can read more about Active Record migrations <a href="http://guides.rubyonrails.org/active_record_migrations.html">here</a>. 

4.) Add a models.rb file to the project folder and require this file into the main application file, app.rb. In the models.rb file, create the Post class that inherits from Active Record.

```ruby
#app.rb 
#place after require "sinatra/activerecord"  
require "./models.rb"
```

```ruby
#model.rb
class Post < ActiveRecord::Base
end
```

















