class UrlsController < ApplicationController
  include UrlsHelper

  before_filter :authorize, :except => [:router, :create, :new]

  def index
    add_breadcrumb :index
  end

  def new
    @url = Url.new
  end

  def create
    url = finnesse_url(url_params[:url])
    if url
      user_id = current_user.nil? ? nil : current_user.id
      @url = Url.create(url: url, user_id: user_id)
      if generate_shortened_path
        url = full_url(@url.shortened_path)
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

end
