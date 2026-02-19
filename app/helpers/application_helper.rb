module ApplicationHelper
  include Pagy::Frontend

  def flash_class(type)
    case type.to_s
    when "notice", "success"
      "bg-green-50 text-green-800 border border-green-200"
    when "alert", "error"
      "bg-red-50 text-red-800 border border-red-200"
    else
      "bg-blue-50 text-blue-800 border border-blue-200"
    end
  end

  def role_badge_class(role)
    case role.to_s
    when "admin"
      "bg-red-100 text-red-800"
    when "employer"
      "bg-blue-100 text-blue-800"
    else
      "bg-green-100 text-green-800"
    end
  end

  def status_badge_class(status)
    case status.to_s
    when "applied"
      "bg-blue-100 text-blue-800"
    when "reviewed"
      "bg-yellow-100 text-yellow-800"
    when "interview"
      "bg-purple-100 text-purple-800"
    when "offer"
      "bg-green-100 text-green-800"
    when "rejected"
      "bg-red-100 text-red-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end

  def job_type_badge_class(job_type)
    case job_type.to_s
    when "full_time"
      "bg-indigo-100 text-indigo-800"
    when "part_time"
      "bg-teal-100 text-teal-800"
    when "contract"
      "bg-orange-100 text-orange-800"
    when "remote"
      "bg-green-100 text-green-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end

  def format_salary(min, max)
    parts = []
    parts << number_to_currency(min, precision: 0) if min.present? && min > 0
    parts << number_to_currency(max, precision: 0) if max.present? && max > 0
    parts.join(" – ")
  end

  def pagy_nav_tag(pagy)
    return "" unless pagy.pages > 1

    html = +""
    html << '<nav class="flex items-center justify-center space-x-1 mt-8">'

    if pagy.prev
      html << link_to("← Prev", url_for(page: pagy.prev), class: "px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50")
    end

    pagy.series.each do |item|
      case item
      when Integer
        html << link_to(item.to_s, url_for(page: item), class: "px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50")
      when String
        html << content_tag(:span, item, class: "px-3 py-2 text-sm font-medium text-white bg-indigo-600 border border-indigo-600 rounded-md")
      when :gap
        html << content_tag(:span, "…", class: "px-3 py-2 text-sm text-gray-500")
      end
    end

    if pagy.next
      html << link_to("Next →", url_for(page: pagy.next), class: "px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50")
    end

    html << "</nav>"
    html.html_safe
  end
end
