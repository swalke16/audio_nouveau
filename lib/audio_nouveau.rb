require 'mp3info'
require 'cgi'
require 'httparty'

path = ARGV[0]
artists = {}

Dir[File.expand_path(File.join(path, '**/*.mp3'))].each do |file|
  begin
    Mp3Info.open(file) do |info|
      url = "http://api.discogs.com/artist/#{CGI::escape(info.tag.artist)}?releases=1"
      response = HTTParty.get(url, :headers => { 'Accept-Encoding' => 'gzip'})

      artists[info.tag.artist] = response["resp"]["artist"]["releases"].select {|release| release["role"].downcase == "main" } unless artists.has_key? info.tag.arist

      puts artists
    end
  rescue Exception => e
    puts e
    puts "file #{file} does not appear to be a valid mp3."
  end
end

