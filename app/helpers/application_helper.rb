module ApplicationHelper
  def display_notice_and_alert
    msg = ''
    msg << (content_tag :div, notice, class: "flash-notice") if notice
    msg << (content_tag :div, alert, class: "flash-alert") if alert
    sanitize msg
  end
end
