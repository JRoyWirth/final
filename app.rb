# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sinatra/cookies" 
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                 #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

user_table = DB.from(:user)
recipe_table = DB.from(:recipe)
comment_table = DB.from(:comment)

# established the following code before taking any other route
before do

    puts "params: #{params}"
    @user_table = user_table
    @current_user = @user_table.where(id: session["user_id"]).to_a[0]

    # API credentials (found on your Twilio dashboard)
    account_sid = ENV["TWILIO_ACCOUNT_SID"]
    auth_token = ENV["TWILIO_AUTH_TOKEN"]
    client = Twilio::REST::Client.new(account_sid, auth_token)
    from = '+12057517322' # Twilio number
    to = '+16307075213' # Your mobile phone number
end

get "/" do
    view "index"
end

post "/login/create" do
    puts "params: #{params}"

    @user = @user_table.where(email: params["email"]).to_a[0]
    pp @user

    if @user
        if BCrypt::Password.new(@user[:pwd]) == params["pwd"]
            
            # know the user is logged in -> rack.session is what will show up in dev tools with an encrypted ID
            session["user_id"] = @user[:id]

            view "create_login"
        else
            view "fail"
        end
    else 
        view "fail"
    end
end

get "/signup" do
    view "signup"
end

post "/signup/create" do
    puts "params: #{params}"
    
    user_table.insert(
        namefirst: params["namefirst"],
        namelast: params["namelast"],
        email: params["email"],
        pwd: BCrypt::Password.create(params["pwd"])
    )

    # send the SMS from your trial Twilio number to your verified non-Twilio number
    client.messages.create(
        from: from, 
        to: to,
        body: "New user alert"
    )

    view "create_user"
end

get "/home" do
    puts "params: #{params}"

    pp recipe_table.all.to_a
    @recipes = recipe_table.all.to_a

    view "home"
end

get "/submit" do
    puts "params: #{params}"
    view "submit"
end

post "/recipe/create" do
    puts "params: #{params}"
      

    recipe_table.insert(
        user_id: session["user_id"],
        year: params["year"],
        kwest: params["kwest"],
        title: params["title"],
        shortdesc: params["shortdesc"],
        whyrecipe: params["whyrecipe"],
        location: params["location"],
        subs: params["subs"],
        directions: params["directions"],
        meal: params["meal"],
        meatless: params["meatless"],
        dairyfree: params["dairyfree"],
        glutenfree: params["glutenfree"],  
    )

    client.messages.create(
        from: "+12057517322", 
        to: "+16307075213",
        body: "New recipe alert"
    )

    view "create_recipe"
end

#do I need a new get for every webpage? 

get "/recipe/:id" do
    puts "params: #{params}"

    pp recipe_table.where(id: params["id"]).to_a[0]
    @recipe = recipe_table.where(id: params["id"]).to_a[0]

    @comment_table = comment_table

    @comment = comment_table.where(recipe_id: @recipe[:id]).to_a[0]
    

    view "recipe"
end

get "/recipe/:id/comment/new" do
    puts "params: #{params}"

    @recipe = recipe_table.where(id: params["id"]).to_a[0]

    view "new_comment"
end

post "/recipe/:id/comment/create" do
    puts "params: #{params}"
    
    @recipe = recipe_table.where(id: params["id"]).to_a[0]

    comment_table.insert(
        user_id: session["user_id"],
        recipe_id: params["id"],
        like: params["like"],
        comment: params["comment"]  
    )

    client.messages.create(
        from: "+12057517322", 
        to: "+16307075213",
        body: "New comment alert"
    )

    view "create_comment"
end

get "/logout" do
    session["user_id"] = nil
    view "create_logout"
end