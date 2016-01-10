# Sinatra/ActiveRecord/sqlite3 App: Simple Steps

"<a href="http://www.sinatrarb.com/intro.html">Sinatra</a> is a DSL for quickly creating web applications in Ruby with minimal effort"

"<a href="https://github.com/janko-m/sinatra-activerecord">Sinatra ActiveRecord Extension</a> extends Sinatra with extension methods and Rake tasks for dealing with an SQL database using the ActiveRecord ORM."

"<a href="http://guides.rubyonrails.org/active_record_basics.html">Active Record</a> is the M in MVC - the model - which is the layer of the system responsible for representing business data and logic. Active Record facilitates the creation and use of business objects whose data requires persistent storage to a database."

## Part One: Extend Sinatra with Active Record, Rake, and sqlite3

1.) Create project directory and cd into it

```bash
$ mkdir building_sinatra_blog_app
$ cd building_sinatra_blog_app
```

2.) Add a Gemfile (no file extension) that includes the gems needed for the application. Rake will let us use command line tasks for migrations (how we will interact with our database), and sqlite is a simple database adapter (DBMS).

```ruby
#Gemfile
source "http://rubygems.org"

gem "sinatra-activerecord"
gem "rake"
gem "sqlite3"
```

3.) Install the gems. This generates the Gemfile.lock file. 

```bash
$ bundle install
```

4.) Create the main application file (app.rb) and require in "sinatra" and "sinatra/activerecord".  Set the database. Notice the syntax of the second argument of the set method. 

```ruby
# app.rb
require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:myblogdb.sqlite3"
```

5.) Create a Rakefile (no file extension). This file locates and loads the command line tasks we will use to create and run migrations.

```ruby
#Rakefile

require "./app"
require "sinatra/activerecord/rake"
```

6.) Use a command line rake task to create the database. This will create the database file. 

```bash
$ rake db:create
```

### Part One Recap
At this point, we have installed the necessary gems for Rake, ActiveRecord and sqlite3, created the main application file, set the database, and created a Rakefile which has allowed us to use a command line rake task to create the database.

The app we want to build is a basic blog that allows a user to add a post with a title and a body. We will create a database table called posts that has three columns: a string column called title, a text column called body, and a timestamps column (which gives us two automatic datetime columns called created_at and updated_at). We'll model the posts with an Active Record model class called Post. 

## Part Two: Create the posts Database Table (posts) and Model class (Post)

We will do two things in this step: add a posts table to the empty database and create a class called Post (an Active Record model), that Activ Record will map to the posts table. This will allow us to make queries on the posts table using Active Record methods. Notice the class "Post" is singular and capitalized, while the database "posts" table is plural and lowercase. 


You can read more about Object-Relational Mapping (ORM) and Active Record <a href="http://guides.rubyonrails.org/active_record_basics.html">here</a>. 

1.) Use a command line rake task to create a migration with the name parameter set to create_posts. 

```ruby
$ rake db:create_migration NAME=create_posts
```
This will create a migration file (a ruby file found in db/migrations) with the given NAME, preceeded by a timestamp. The migration file is a ruby class with a method called change. 

You can get a list of the rake tasks via the command line by typing the rake command with a -T flag. 

```bash
$ rake -T
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

2.) To the change method within the newly created migration, add a block that creates a posts table with the desired columns. The create_table method takes the table name (should be lowercase and plural) as a symbol and sets the columns.  

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

The change method will get called when the migration is run.

3.) Use the command line rake task to run the migration.

```bash
$ rake db:migrate
```

Because this is our first migration, the db/schema.rb file is generated. This file should not be touched and represents the up to date structure of your database. You can read more about Active Record migrations <a href="http://guides.rubyonrails.org/active_record_migrations.html">here</a>. 

4.) Now that we have a posts table, we need a Post model. Add a models.rb file to the project folder and require this file into the main application file, app.rb. In the models.rb file, create the Post class (model) that inherits from Active Record.

Create a models.rb file within the project folder and add the Post class:
```ruby
#models.rb
class Post < ActiveRecord::Base
end
```
Require the newly created models.rb file in app.rb:
```ruby
#app.rb 
#place after require "sinatra/activerecord"  
require "./models.rb"
```


### Part Two Recap

At this point, we have set up the app, the database, added a posts table and a Post model. Our posts table has 4 columns for title, body, created_at, and updated_at. We do not yet have any posts or a way for a user to add posts. 

## Part Three: Using Active Record Methods to CRUD it up

We do not need posts in our table to start building out our app. However, let's take a break to explore Active Record. If we enter irb from within the application folder and require in the Post model, we can make queries to the database using Active Record methods. Let's use irb to add records to our posts table.


1.) Start up irb and require the main app file, app.rb.

Start up irb
```bash
$ irb
```

In irb, require in the main application file so we can use the Post class.
```bash
> require './app'
```
2.) CREATE 
Use the .create method to create and save a new record.



This is entered:
Post.create(title: "Hello World!", body: "All work and no play makes Jack a dull boy") 
This is returned:
```bash
#<Post id: 1, title: "Hello World!", body: "All work and no play makes Jack a dull boy", created_at: "2016-01-10 16:17:50", updated_at: "2016-01-10 16:17:50", user_id: nil>
```

NOTE: The full irb is pasted below. Take note of the irb prompt ">" and return "=>"
```bash
irb(main):002:0> Post.create(title: "Hello World!", body: "All work and no play makes Jack a dull boy") 
D, [2016-01-10T11:17:50.750399 #5161] DEBUG -- :    (0.1ms)  begin transaction
D, [2016-01-10T11:17:50.754733 #5161] DEBUG -- :   SQL (0.4ms)  INSERT INTO "posts" ("title", "body", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "Hello World!"], ["body", "All work and no play makes Jack a dull boy"], ["created_at", "2016-01-10 16:17:50.752267"], ["updated_at", "2016-01-10 16:17:50.752267"]]
D, [2016-01-10T11:17:50.757139 #5161] DEBUG -- :    (2.0ms)  commit transaction
=> #<Post id: 1, title: "Hello World!", body: "All work and no play makes Jack a dull boy", created_at: "2016-01-10 16:17:50", updated_at: "2016-01-10 16:17:50", user_id: nil>
```

Or, use the .new and .save method. The .save method is required to actualy save (persist) the record. 

The commands entered into irb 
* irb(main):003:0> post = Post.new
* irb(main):004:0> post.title = "Another Post"
* irb(main):005:0> post.body = "This is another post."
* irb(main):006:0> post.save

NOTE: full irb print out pasted below:
```bash
irb(main):003:0> post = Post.new
=> #<Post id: nil, title: nil, body: nil, created_at: nil, updated_at: nil, user_id: nil>
irb(main):004:0> post.title = "Another Post"
=> "Another Post"
irb(main):005:0> post.body = "This is another post"
=> "This is another post"
irb(main):006:0> post.save
D, [2016-01-10T11:18:50.439821 #5161] DEBUG -- :    (0.1ms)  begin transaction
D, [2016-01-10T11:18:50.441713 #5161] DEBUG -- :   SQL (0.4ms)  INSERT INTO "posts" ("title", "body", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["title", "Another Post"], ["body", "This is another post"], ["created_at", "2016-01-10 16:18:50.440221"], ["updated_at", "2016-01-10 16:18:50.440221"]]
D, [2016-01-10T11:18:50.447183 #5161] DEBUG -- :    (4.9ms)  commit transaction
=> true
```

4.) READ: 
The .all method returns a collection of all records in the table. The collection is of Active Record objects and is Array-like. 

NOTE: full irb print out below:
```bash
irb(main):007:0> Post.all
D, [2016-01-10T11:19:23.567266 #5161] DEBUG -- :   Post Load (0.4ms)  SELECT "posts".* FROM "posts"
=> #<ActiveRecord::Relation [#<Post id: 1, title: "Hello World!", body: "All work and no play makes Jack a dull boy", created_at: "2016-01-10 16:17:50", updated_at: "2016-01-10 16:17:50", user_id: nil>, #<Post id: 2, title: "Another Post", body: "This is another post", created_at: "2016-01-10 16:18:50", updated_at: "2016-01-10 16:18:50", user_id: nil>]>
```
.first returns the first post as an Active Record object.

NOTE: full irb print out below:
```bash
irb(main):008:0> Post.first
D, [2016-01-10T11:19:50.455731 #5161] DEBUG -- :   Post Load (0.3ms)  SELECT  "posts".* FROM "posts"  ORDER BY "posts"."id" ASC LIMIT 1
=> #<Post id: 1, title: "Hello World!", body: "All work and no play makes Jack a dull boy", created_at: "2016-01-10 16:17:50", updated_at: "2016-01-10 16:17:50", user_id: nil>
```
Return the post with a primary key of 1 as an Active Record object.

NOTE: full irb print out pasted below:
```bash
irb(main):009:0> Post.find(1)
D, [2016-01-10T11:20:09.757001 #5161] DEBUG -- :   Post Load (0.3ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT 1  [["id", 1]]
=> #<Post id: 1, title: "Hello World!", body: "All work and no play makes Jack a dull boy", created_at: "2016-01-10 16:17:50", updated_at: "2016-01-10 16:17:50", user_id: nil>
```

3.) UPDATE
We can use .update to update an Active Record object's attributes. Once you have an Active Record object, you can use .update and pass in the updated attributes.

@post = Post.first
@post.update(title: "Hello", body: "Is it me you're looking for?")

4.) DELETE: .delete and .destroy
.delete uses SQL directly (faster)
.destroy loads the instance and then calls destroy on it as an instance method. The destroy method removes the object from the database and prevents you from modifying it again

ex. retrieve and destroy 
	*	post = Post.find(1)
	*	post.destroy

You can also call .destroy and .delete as class methods, passing the id(s) to the method.
ex. 
	* Post.delete(1)

## Part Four: Using Active Record in Sinatra routes and views 

### Sinatra Routes
* Routes are how an app handles incoming requests. 
* In Sinatra, a route is an HTTP method paired with a URL-matching pattern.
* Each route is associated with a block:
```ruby
get ‘/‘ do
	… some code…
end

post ‘/‘ do
	…some code…
end
```

### HTTP Methods

* HTTP is the client-server protocol for data communication for the web.
* There are several HTTP methods associated with this communication. We’ve looked at two:
** GET is an HTTP method used to get/retrieve data from a server. 
*** ex. getting a webpage
** POST is an HTTP method used to send/post data to the server
*** ex. posting input submitted via an HTML form.

### Sinatra Views
* Views: What the client sees
* ERB (Embedded Ruby) is a templating system that is part of the Ruby standard library (you do not install it)
* ERB recognizes certain tags in the provided template and converts them based on the rules below:
```erb
<% Ruby code -- inline with output %>
<%= Ruby expression -- replace with result %>
<%# comment -- ignored -- useful in testing %>
```
* Sinatra assumes templates are located in a folder called “views”. 
* Sinatra gives us a rendering method “erb”. When the erb method is passed a symbol, Sinatra will look inside of the views folder for a match. 
ex.
```ruby  
get ‘/‘ do
	erb :index
end
```
The above specifies that when an HTTP get request to the root route comes in, the index template in the views folder will be rendered.

** If there is a layout.erb file in the views folder, Sinatra will render that first. 

## Let's add some routes
Let's say we want to have a home page that displays all of our posts and has a form to enter a new post. 
1. We need a route that handles an HTTP GET request to the root route. Within the do block, we can use Post.all to return a collection of all of the posts in the table. We can set that Array-like colection to an instance variable of @posts. We would like to use this instance variable in the index page. On the index page, we can loop through and display all of the posts in the collection.

```ruby
get “/“ do
	@posts = Post.all
	erb :index
end
```

2.) Now we need an index view (a template in the views folder). Sinatra will first look inside of a folder called views for an optional template called layout. Let's create a layout template that will render before all views. Create a views folder within your project folder and add a layout.erb template. We put a <%= yield %> in the template where we would like the other views rendered. Let's add the html scaffolding and a site-wide navigation menu (just a link to the home page) to the template. 

Add a views folder with a layout.erb file to your project folder. 
```html
<!-- views/layout.erb -->
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Sinatra Blog</title>
</head>
<body>
 <ul>
   <li><a href="/">Home</a></li>
 </ul>
 <%= yield %>
</body>
</html>
```

3.) Now we can add the index view which will list all of our posts and contain a form for adding a new post. 
The @posts instance variable defined in the root route (in app.rb) is enumerable (Array-like -we can use an .each method to loop through it) collection of Active Record objects. These objects represent records from the post table and we can access the column for each row via an attibute (ex: post.title). We can also use an anchor tag and generate a unique link (an href attribute) for each post that contains the individual records' primary key. A click on an anchor tag makes an HTTP get request. We will be able make a route that matches the URL pattern (href="/posts/<%= post.id %>") that will render an erb that will show detailed info of a specific post. 
We add a form with method="post" (an HTTP post request) and action ="/post" attributes. The form will have inputs for title and body. When the form is submitted, a post request to "/post" with title and body params will be made. We will handle this route in our app.rb file. First, let's add the index.erb file to the views folder.  
```html
<!-- views/index.erb -->
<h2>All Posts</h2>
<ul>
<% @posts.each do |post| %>
 <li>
   <a href="/post/<%= post.id %>"><%= post.title %></a> | <%= post.created_at %>
 </li>
<% end %>
</ul>
<h2>Add Post</h2>
<form method="post" action="/post">
		<label for="title">Title: </label>
   <input type="text" name="title">
   <label for="body">Body: </label>
   <input type="text" name="body">
   <input type ="submit" value="Add Post">
</form>
```

READ route and view for reading each post
3.) We've generated anchor tags with unique urls for each post on the index view. These links will make HTTP get requests to a url with the form of '/post/1', with the number corresponding with the primary key of the post. We can use Sinatra route pattern matching to generate a route match: "posts/:id". We can then access the primary key via the params hash params[:id]. Add a route to app.rb that matches the incomming get request, looks up the post by incomming params[:id], and then renders a new view called post_page.erb. 

```ruby
get "/post/:id" do
 @post = Post.find(params[:id])
 erb :post_page
end
```
4.) On the post page, we will display the post title and body and a link to delete the post and a form to edit the post. We can work around some limitations with how browsers handle delete and put requests by using a helper method. We use the name and value attributes to pass the particular method to the router.  We set the name="_method" and the value attribute to match the http request (put or delete) we would like to make with the link or form.

```ruby
<!-- views/post_page.erb -->
<h2><%= @post.title %></h2>
<p>Created: <%= @post.created_at %></p>
<p><%= @post.body %></p>
<a href="/post/<%= @post.id %>" name="_method" value="delete">Delete Post</a>

<h2>Edit Post</h2>
<form method="post" action="/post/<%= @post.id %>"> 
    <input type="hidden" name="_method" value="put">
    <input type="text" name="title" value="<%= @post.title %>">
    <input type="text" name="body" value="<%= @post.body %>">
    <button type="submit">Update Post</button>
</form>
```
Set the routes
We need to add a route for when the form for a new post is submitted. As specified by the action and method attributes of the form, this will be an HTTP post request sent to the "/post" URL.

```ruby
# create post
post '/post' do
	@post = Post.create(title: params[:title], body: params[:body])
	redirect '/'
end
```

We need to add a route to handle the edit form for the post. The name = "_method" and value="update" attributes will lead to an HTTP PUT request, while the action="/post/<%= @post.id %>" will generate a URL of the form "/post/1", with the number correpsonding to the primary key of the post that needs to be updated. Again, we can use Sinatra route pattern matching: "post/:id" and access the primary key via the params hash. We then redirect the user to the newly updated individual post page.

```ruby
# update post
put '/post/:id' do
	@post = Post.find(params[:id])
	@post.update(title: params[:title], body: params[:body])
	@post.save
	redirect '/post/'+params[:id]
end 
``` 
We need to add a route to handle the delete link for the post. The name = "_method" and value="delete" attributes will lead to an HTTP DELETE request, while the href="/post/<%= @post.id %>" will generate a URL of the form "/post/:id". We look up the record by the params[:id] and then destroy it. We redirect the user to the home page.

```ruby
# delete post
delete '/post/:id' do
	@post = Post.find(params[:id])
	@post.destroy
	redirect '/'
end
```








