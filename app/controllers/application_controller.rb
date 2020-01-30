require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, ENV["SESSION_SECRET"] || "fashjkfdsajhkwebnewfhiugdhiuwfbhiuewfuabhshldj"
    enable :sessions, :logging
    register Sinatra::Flash
  end

  def current_user_id
    session[:user_id]
  end

  def current_user
    if logged_in?
      @user ||= User.find(current_user_id) 
    end
  end

  def logged_in?
    !!current_user_id
  end

  get "/" do
    if logged_in?
      @user = User.find(session[:user_id]) 
      @users = User.includes(:clicks).sort_by(&:points).reverse
    end
    erb :welcome
  end

  get "/create-points" do
    if logged_in?
      click = current_user.click!
      flash[:points] = click.value
    end
    redirect to "/"
  end

  get "/login/:token" do
    user = User.find_by(auth_token: params[:token])
    session[:user_id] = user.id if user
    redirect to "/"
  end

end
