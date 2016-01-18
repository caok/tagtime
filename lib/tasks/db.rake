namespace :db do 
  desc "Dumps the database to backups"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      if user.blank?
        cmd = "pg_dump -h #{host} -p 5432 -d #{db} > #{Rails.root}/db/backups/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{db}.psql"
      else
        cmd = "pg_dump -h #{host} -p 5432 -U #{user} -d #{db} > #{Rails.root}/db/backups/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{db}.psql"
      end
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database from backups, eg: rake 'db:restore[20151120095657]'"
  task :restore, [:date] => :environment do |task,args|
    if args.date.present?
      cmd = nil
      with_config do |app, host, db, user|
        cmd = "psql -h #{host} -p 5432 -d #{db} -f #{Rails.root}/db/backups/#{args.date}_#{db}.psql"
      end
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      puts cmd
      exec cmd
    else
      puts 'Please pass a date to the task'
    end
  end

  private
  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end
end
