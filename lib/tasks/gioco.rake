# -*- encoding: utf-8 -*-
namespace :gioco do
  
  desc "Used to add a new badge at Gioco scheme"
  
  task :add_badge, [:name, :points, :default] => :environment do |t, args|
    arg_default = ( args.default ) ? eval(args.default) : false


    if !args.name || !args.points
      raise "There are missing some arguments"
    else
      badge_string = ""

      badge_string = badge_string + "badge = Badge.create({ 
                      :name => '#{args.name}', 
                      :points => '#{args.points}',
                      
                      :default => '#{arg_default}'
                    })
"

      if arg_default
        badge_string = badge_string + 'resources = User.find(:all)
'
        badge_string = badge_string + "resources.each do |r|
        r.points = '#{args.points}'
          r.badges << badge
          r.save!
        end
"
      end
      
      badge_string = badge_string + "puts '> Badge successfully created'"

      eval badge_string
      
      file_path = "/db/gioco/create_badge_#{args.name}.rb"
      File.open("#{Rails.root}#{file_path}", 'w') { |f| f.write badge_string }
      File.open("#{Rails.root}/db/gioco/db.rb", 'a') { |f| f.write "require \"\#\{Rails.root\}#{file_path}\"
" }

    end

  end

  desc "Used to remove an old badge at Gioco scheme"

  task :remove_badge, [:name] => :environment do |t, args|
    if !args.name
      raise "There are missing some arguments"
    else
      badge_string = "
      badge = Badge.where( :name => '#{args.name}' ).first
      badge.destroy
"
    end

    badge_string = badge_string + "puts '> Badge successfully removed'"

    eval badge_string
    
    file_path = "/db/gioco/remove_badge_#{args.name}.rb"
    File.open("#{Rails.root}#{file_path}", 'w') { |f| f.write badge_string }
    File.open("#{Rails.root}/db/gioco/db.rb", 'a') { |f| f.write "require \"\#\{Rails.root\}#{file_path}\"
" }
  end
  
end
