namespace :import do 
  desc "import form toggle"
  task :toggle => :environment do
    require 'csv'
    count = 0
    CSV.foreach("./Toggl_time.csv") do |row|
      user = User.find_by(name: row[0].try(:downcase))
      project = Project.find_by(name: row[3])
      num = row[5].match(/\#(\d+)[ ;,.，。]?/)[1] rescue 0
      content = num.to_i > 0 ? row[5].gsub("##{num}", "") : row[5]
      if user.present?
        Issue.create(user_id: user.try(:id),
                     project_id: project.try(:id),
                     happened_at: row[7],
                     spend_hour: row[11].split(":").first.to_i,
                     spend_minutes: row[11].split(":").second.to_i,
                     content: content,
                     number: num.to_i,
                     original_content: row[5]
                    )
        count += 1
        puts count
      end
      puts "import #{count}"
    end
  end
end
