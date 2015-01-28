require 'rubygems'
require 'yaml'
require 'riak'

# Riak client
client = Riak::Client.new()
bucket = client.bucket("quizzes")
begin
  index_obj = bucket.get("_index")
  if index_obj.data
    index = JSON.parse(index_obj.data)
  else
    index = []
  end
rescue
  index_obj = bucket.new("_index")
  index = []
end

Dir["quizzes/*"].each do |quiz|
  data = YAML.load(IO.read(quiz))
  key = File.basename(quiz, File.extname(quiz))
  puts key
  obj = bucket.new(key)
  obj.data = data
  obj.store
  index << key
end

index_obj.data = index
index_obj.store
