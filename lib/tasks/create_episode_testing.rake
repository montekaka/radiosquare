# encoding: UTF-8
desc "Create Episodes"
require 'rest_client'
require 'crack'
require "cgi"	
require 'json'
task :create_episodes_testing => :environment do
	resp = 'https://dl.dropboxusercontent.com/u/9338310/Picture/justcast.json'
	feed = JSON.parse(open(resp).read)['feed']['entry']
	podcast = Podcast.find_by_name('JustCast')
	feed.each do |e|
		title = e['title']['$t']
		url = e['content']['$t']
		episode_create = Episode.create(:name=>title, :podcast_id=>podcast.id,:url=>url)
		episode_create.save!
	end
end