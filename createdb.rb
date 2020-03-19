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
  String :subs, text: true
  String :directions, text: true
  #String :photo
  String :headshot
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
recipe_table = DB.from(:recipe)

recipe_table.insert(
                    user_id: "1",
                    year: "2021",
                    kwest: "Amazing Race",
                    title: "BBQ Ribs",
                    shortdesc: "Sous-vide style midwestern BBQ ribs with homemade sauce",
                    whyrecipe: "Growing up, I only ate 3 foods at resturants: fried catfish, apple pie and ribs but each is best homemade!",
                    location: "Illinois, U.S.A.",
                    ingredients: "1 rack BBQ ribs, brown sugar, spices",
                    subs: "instead of using extra sauce, try reapplying dry rub",
                    directions: "1. pat ribs dry...",
                    headshot: "https://images.app.goo.gl/fYWKfTdH3RG5LGGv7",
                    meal: "Dinner",
                    meatless: "0",
                    dairyfree: "1",
                    glutenfree: "1"
                    )

recipe_table.insert(
                    user_id: "2",
                    year: "2021",
                    kwest: "Amazing Race",
                    title: "Lasagna",
                    shortdesc: "Lasagna with meat sauce",
                    whyrecipe: "Every year on Christmas Day my dad would make stuffed shells or lasagna. This lasagna is what dreams are made of",
                    location: "Scottsdale, Arizona",
                    ingredients: "1. box lasagna, 8 oz tomato paste, 1 bunch fresh basil",
                    subs: "use eggplant slices instead of ground meats",
                    directions: "1. cut italian sausage length-wise...",
                    headshot: "https://images.app.goo.gl/fYWKfTdH3RG5LGGv7",
                    meal: "Dinner",
                    meatless: "0",
                    dairyfree: "0",
                    glutenfree: "0"
                    )

recipe_table.insert(
                    user_id: "3",
                    year: "2021",
                    kwest: "Amazing Race",
                    title: "Vegetarian Pulled BBQ Sandy",
                    shortdesc: "A vege take on a Texas classic BBQ handheld",
                    whyrecipe: "Being both a diehard Texan and a dedicated vegetarian, sounds tough but this dish proves otherwise!",
                    location: "Texas",
                    ingredients: "1 can jackfruit, 8 oz BBQ sauce (thick and spicy)",
                    subs: "n/a",
                    directions: "1. put jackfruit and sauce in a slowcooker...",
                    headshot: "https://images.app.goo.gl/fYWKfTdH3RG5LGGv7",
                    meal: "Lunch",
                    meatless: "1",
                    dairyfree: "1",
                    glutenfree: "0"
                    )

user_table = DB.from(:user)

user_table.insert(
                    namefirst: "Jason",
                    namelast: "Wirth",
                    email: "jason.wirth@kellogg.northwestern.edu",
                    pwd: "1234"
                    )

user_table.insert(
                    namefirst: "Sarah",
                    namelast: "Wirth",
                    email: "sarahnwirth@gmail.com",
                    pwd: "1234"
                    )

user_table.insert(
                    namefirst: "Sai",
                    namelast: "Guntari",
                    email: "sai.guntari@kellogg.northwestern.edu",
                    pwd: "1234"
                    )



puts "Success!"