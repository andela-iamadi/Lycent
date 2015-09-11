class UrlsController < ApplicationController
  include UrlsHelper

  before_filter :authorize, :except => [:router, :create, :new, :shorten]

  def index
    add_breadcrumb :index
  end

  def new
    @url = Url.new
  end

  def create
    url = finnesse_url(url_params[:url])
    if url
      save_url url
    else
      flash[:danger] = "Please type in a url in the textbox below"
    end
    redirect_to request.referrer
  end

  def show
    @url = Url.includes(:hits).find_by(id: params[:id]) || nil
    if @url
      @url_hits = @url.hits
      add_breadcrumb :show, url_path(@url)
    end
  end

  def edit
    add_breadcrumb :edit, edit_url_path(@url)
  end

  def shorten
    @url = Url.new
    user_id = current_user.nil? ? request.remote_ip : current_user.id
    @urls =  Url.where(user_id: user_id).limit(10)
    render template: "urls/shorten"
  end

  def update

  end

  def delete

  end

  private

  def save_url url
    user_id = current_user.nil? ? request.remote_ip : current_user.id
    @url = Url.create(url: url, user_id: user_id)
    if generate_shortened_path
      save_success
    else
      save_error
    end
  end

  def save_success
    url = full_url(@url.shortened_path)
    @current_user.reload if @current_user
    respond_to do |format|
      format.html do
        flash[:success] = "Shortened url: <a href=\"#{url}\">#{url}</a>"
        redirect_to :shorten if !@current_user and return
      end
      format.js # {render 'create.js'}
    end
  end

  def save_error
    respond_to do |format|
      format.html do
        flash[:danger] = "Ummm...seems your url #{@url.errors.messages[:url][0]}. Cross-check, then try again."
        redirect_to :shorten if !@current_user and return 
      end
      format.js
    end
  end
end
