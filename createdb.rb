# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :user do
  primary_key :id
  String :namefirst
  String :namelast
  String :email
  String :pwd
end

DB.create_table! :recipe do
  primary_key :id
  foreign_key :user_id
  String :year
  #String :program
  String :kwest
  String :title
  String :shortdesc
  String :whyrecipe, text: true
  String :location
  String :ingredients, text: true
  String :directions, text: true
  #String :photo
  #String :headshotf
  String :meal
  Boolean :meatless
  Boolean :dairyfree
  Boolean :glutenfree
end

DB.create_table! :comment do
  primary_key :id
  foreign_key :user_id
  foreign_key :recipe_id
  Boolean :like
  String :comment, text: true
end

# Insert initial (seed) data
events_table = DB.from(:events)

events_table.insert(title: "Bacon Burger Taco Fest", 
                    description: "Here we go again bacon burger taco fans, another Bacon Burger Taco Fest is here!",
                    date: "June 21",
                    location: "Kellogg Global Hub")

events_table.insert(title: "Kaleapolooza", 
                    description: "If you're into nutrition and vitamins and stuff, this is the event for you.",
                    date: "July 4",
                    location: "Nowhere")
