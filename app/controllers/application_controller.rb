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
      @users = User.includes(:clicks, :transfers_to, :transfers_from).sort_by(&:points).reverse
    end
    erb :welcome
  end

  get "/create-points" do
    if logged_in?
      if current_user.can_click?
        click = current_user.click!
        flash[:points] = click.value
      else
        flash[:error] = :forbidden_click
      end
    end
    redirect to "/"
  end

  get "/transfer-points/:user_slug/:points" do
    if logged_in?
      destination_user = User.find_by(slug: params[:user_slug])
      if destination_user
        transfer = Transfer.create(from: current_user, to: destination_user, points: params[:points])
        if transfer.affordable?
          flash[:transfer] = { to: destination_user.name, points: transfer.points }
        end
      end
    end
    redirect to "/"
  end

  get "/login/:token" do
    user = User.find_by(auth_token: params[:token])
    session[:user_id] = user.id if user
    redirect to "/"
  end

end
