# encoding: UTF-8
desc "Create Podcasts"
task :create_podcasts_testing => :environment do
	shows = ["JustCast"]
	shows.each do |show|
		podcast = Podcast.create(:name=>show)
		podcast.save!
		puts "#{show} created"
	end
end