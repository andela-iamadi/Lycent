module UrlsHelper

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

    def finnesse_url url
      url = ((url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]) ? url : "http://#{url}") if !url.nil? || !url.empty?
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
      hit.referrer = session[:referrer] || ""
      hit.city = request.location.data["city"]
      hit.zipcode = request.location.data["zipcode"]
      hit.country = request.location.data["country_name"]
      hit.save
    end

    def full_url path
      url = "{#{host_url}}/#{@url.shortened_path}"
    end

    def host_url
      Rails.env.production? ? "#{Rails.application.secrets.app_url}/#{@url.shortened_path}" : "#{Rails.application.secrets.app_url}:#{request.port}"
    end
end
