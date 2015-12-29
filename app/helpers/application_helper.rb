module ApplicationHelper
  def display_notice_and_alert
    msg = ''
    msg << (content_tag :div, notice, class: "flash-notice") if notice
    msg << (content_tag :div, alert, class: "flash-alert") if alert
    sanitize msg
  end

  def can_manage_member?(user, member)
    return false if member.is_owner?

    project = member.project
    manager_ids = project.managers.map(&:id)
    if manager_ids.include? user.id
      true
    else
      false
    end
  end
end
