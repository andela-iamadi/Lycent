module ApplicationHelper
  def new_url
    @new_url ||= Url.new
  end
end
