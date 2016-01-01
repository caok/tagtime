module TagConcern
  private
  attr_reader :tags
  def generate_params 
    ActionController::Parameters.new(project_id: tags[0],
                                     number: tags[1],
                                     spend_hour: tags[2],
                                     spend_minutes: tags[3],
                                     happened_at: tags[4],
                                     content: tags[5]).permit!
  end

  def break_tag
    # "with feigeofeiofefefiej @feedmob for 11/24 #16 11h:32m" 
    tag = params[:tag].try(:strip) 
    return nil if tag.blank?

    project = tag.match(/\@\w+[ ;,.，。]?/).to_s
    date = tag.match(/for\s(\w+\/\w+)[ ;,.，。]?/)
    content = tag.match(/with\s(.+)@/)

    number = tag.match(/\#\d+[ ;,.，。]?/).to_s
    hours = tag.match(/[\d.]+(hrs|hr|h|H)+/).to_s
    minutes = tag.match(/[\d.]+(mins|min|m|M)+/).to_s

    # [project,number,hours,minutes].each {|s| content = content.gsub(/#{s}/, '')}
    #

    content = match_content(content)
    date = match_date(date)

    number = number.gsub(/[# ;,，。]/, '')
    hours = hours.gsub(/(hrs|hr|h|H)/, '').to_f
    minutes = minutes.gsub(/(mins|min|m|M)/, '').to_i

    project = project.gsub(/[@ ;,，。]/, '').try(:downcase)
    project_id = Project.find_by(name: project).try(:id)

    if hours != hours.to_i
      minutes = (minutes + (hours - hours.to_i)*60).to_i
      hours = hours.to_i
    end 

    @tags = [project_id, number, hours.to_i, minutes, date, content]
  end

  def match_content(content)
    if content
      content = content.length > 1 ? content[1].strip : "" 
    else
      content = ""
    end 
  end

  def match_date(date)
    if date
      date = date.length > 1 ? generate_date(date[1]) : Date.today
    else
      date = Date.today
    end 
  end

  def generate_date(date_str) 
    if date_str.include?('/')
      dates = date_str.split('/')
      return Date.new(Time.now.year, dates[0].to_i, dates[1].to_i)
    end

    case date_str
    when "yesterday" then DateTime.now.yesterday
    else Date.yesterday
    end
  end 
end
