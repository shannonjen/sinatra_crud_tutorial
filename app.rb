# app.rb
require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:myblogdb.sqlite3"

require "./models"

# index posts
get '/' do
	@posts = Post.all
	erb :index
end

# create post
post '/post' do
	@post = Post.create(title: params[:title], body: params[:body])
	redirect '/'
end

# show post
get '/post/:id' do
	@post = Post.find(params[:id])
	erb :post_page
end

# update post
put '/post/:id' do
	@post = Post.find(params[:id])
	@post.update(title: params[:title], body: params[:body])
	@post.save
	redirect '/post/'+params[:id]
end

# delete post
delete '/post/:id' do
	@post = Post.find(params[:id])
	@post.destroy
	redirect '/'
end

























