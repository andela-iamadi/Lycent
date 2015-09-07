class UrlsController < ApplicationController
  before_filter :authorize, :except => [:router]

  def index
    add_breadcrumb :index
  end

  def new
    @url = Url.new
  end

  def create
    url = finnesse_url
    if url
      user_id = @current_user.nil? ? nil : @current_user.id
      @url = Url.create(url: url, user_id: user_id)
      @url.user_id = @current_user.nil? ? nil : @current_user.id
      if generate_shortened_path
        url = "#{Rails.application.secrets.app_url}/#{@url.shortened_path}"
        flash[:success] = "Shortened url: <a href=\"#{url}\">#{url}</a>"
      else
        flash[:danger] = "Ummm...seems your url #{@url.errors.messages[:url][0]}. Cross-check, then try again."
      end
    else
      flash[:danger] = "Please type in a url in the textbox below"
    end
    redirect_to request.referrer
  end

  def show
    @url = Url.find_by(id: params[:id]) || nil
    if @url
      @hits = @url.hits
      add_breadcrumb :show, url_path(@url)
    end
  end

  def edit

    add_breadcrumb :edit, edit_url_path(@url)
  end

  def update

  end

  def delete

  end

  def router
    url = Url.find_by(shortened_path: params[:path])
    if url
      save_hit_details url
      redirect_to "#{url.url}"
    else
      flash[:danger] = "Uh oh. #{Rails.application.secrets.app_url}/#{params[:path]} seems to be an invalid url."
      redirect_to root_path
    end
  end

  private

  def url_params
    params.require(:url).permit(:id, :url, :user_id)
  end

  def finnesse_url
    url = ((url_params[:url].include? "http://") ? url_params[:url] : "http://#{url_params[:url]}") if !url_params[:url].nil? || !url_params[:url].empty?
    url
  end

  def generate_shortened_path
    current_plan = @current_user.nil? ? "f" : "e"
    @url.shortened_path = current_plan + @url.id.to_s
    @url.save
  end

  def save_hit_details url
    hit = url.hits.new
    hit.ip_address = request.remote_ip
    hit.referrer = request.env["HTTP_REFERER"] || 'none'
    hit.save
  end
end
