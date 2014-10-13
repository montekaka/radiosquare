# encoding: UTF-8
desc "Create Episodes"
require 'rest_client'
require 'crack'
require "cgi"	
task :create_episodes => :environment do
	player = '/wp-content/plugins/ap_audio_player/source/folder_parser.php?dir=%2Fshow%2F'
	shows = []
	shows.push({:name=> "今日話題", :station_url=>"http://www.am1300.com"})
	shows.push({:name=> "理財天地", :station_url=>"http://www.am1430.net"})
	shows.each do |show|
		podcast_name = show[:name]
		station_url = show[:station_url]
		podcast = Podcast.find_by_name(podcast_name)		
		if podcast == nil
			podcast_create = Podcast.create(:name=>podcast_name)
			podcast_create.save!
			puts "#{podcast_name} created"
			podcast = Podcast.find_by_name(podcast_name)
		end		
		show_cgi = CGI.escape(podcast_name)
		resp = RestClient.get("#{station_url}#{player}#{show_cgi}"+"&subdirs=false", 'User-Agent' => 'Ruby')
		arr = Crack::JSON.parse(resp)
		has_episode = Episode.find_by_podcast_id(podcast.id)
		if has_episode == nil
			arr.each do |episode|
				episode_name = episode['filename']
				episode_size = episode['size']
				episode_basename = episode['basename']
				episode_lastmod = episode['lastmod']
				episode_url = station_url+'/show/'+podcast_name+'/'+episode_basename
				episode_create = Episode.create(:name=>episode_name, :podcast_id=>podcast.id, :file_size=>episode_size, :lastmod=>episode_lastmod, :url=>episode_url)
				episode_create.save!
				puts "#{episode_name} created"
			end
		else
			# for existing shows, we only check the most recent 10 to find the one to add
			if arr.length < 10
				max_check = arr.length
			else
				max_check = 10
			end			
			i = 0
			while i < max_check
				episode = arr[i]
				episode_name = episode['filename']
				episode_size = episode['size']
				episode_basename = episode['basename']
				episode_lastmod = episode['lastmod']
				episode_url = station_url+'/show/'+podcast_name+'/'+episode_basename
				# check if the show exist from the database
				check_episode = Episode.find_by_name(episode_name)
				if check_episode == nil
					episode_create = Episode.create(:name=>episode_name, :podcast_id=>podcast.id, :file_size=>episode_size, :lastmod=>episode_lastmod, :url=>episode_url)
					episode_create.save!
					puts "#{episode_name} created"
				else
					puts "#{episode_name} does not created"
				end
				i = i + 1
			end 
		end
		sleep 1	
	end
end