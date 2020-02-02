require './config/environment'
require_relative '../helpers/points_to_string'
require_relative '../helpers/time_to_string'
require_relative '../helpers/user_helper'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, ENV["SESSION_SECRET"] || "fashjkfdsajhkwebnewfhiugdhiuwfbhiuewfuabhshldj"
    enable :sessions, :logging
    register Sinatra::Flash
  end

  helpers PointsToString
  helpers TimeToString
  helpers ActionView::Helpers::DateHelper
  helpers UserHelper

  def logged_in_user_id
    session[:user_id]
  end

  def logged_in_user
    if logged_in?
      @logged_in_user ||= User.find(logged_in_user_id) 
    end
  end

  def logged_in?
    !!logged_in_user_id
  end

  get "/" do
    if logged_in?
      @user = User.with_points.find(session[:user_id]) 
      @users = User.with_points.includes(:clicks)
    end
    erb :welcome
  end

  get "/create-points" do
    if logged_in?
      click = logged_in_user.click!
      if click.valid?
        flash[:points] = click.value
      else
        flash[:error] = click.errors.full_messages
      end
    end
    redirect to "/"
  end



  get "/transfer-points/:user_slug" do
    if logged_in?
      destination_user = User.find_by(slug: params[:user_slug])
      if destination_user
        transfer = Transfer.create(from: logged_in_user, to: destination_user, points: params[:points])
        if transfer.valid?
          flash[:transfer] = { to: destination_user.name, points: transfer.points }
        else
          flash[:error] = transfer.errors.full_messages
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

  get "/:user_slug" do
    @user = User.with_points.find_by(slug: params[:user_slug])
    erb :user
  end

  get "/:user_slug/transfers_with/:other_user_slug" do
    users = User.where(slug: [ params[:user_slug], params[:other_user_slug] ]).group_by(&:slug)
    @primary_user = users[params[:user_slug]].first
    @secondary_user = users[params[:other_user_slug]].first
    @transfers = Transfer.includes_users.between(@primary_user, @secondary_user)
                                        .chronologically_desc
    erb :user_transfers_with
  end


end
