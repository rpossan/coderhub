module ApplicationHelper
  def short_url_link(profile)
    link_to("/s/#{profile.short_url}", class: "btn btn-outline-secondary", target: "_blank") do
      content_tag(:i, "", class: "bi bi-link") + " URL Encurtada"
    end
  end
end
