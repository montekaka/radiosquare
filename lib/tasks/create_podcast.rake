# encoding: UTF-8
desc "Create Podcasts"
task :create_podcasts => :environment do
	shows = ["今日話題", "理財天地"]
	shows.each do |show|
		podcast = Podcast.create(:name=>show)
		podcast.save!
		puts "#{show} created"
	end
end