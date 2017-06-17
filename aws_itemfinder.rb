require 'json'
require_relative 'aws_signed'
require_relative 'aws_process_secure'

filename = "citygear.json"
my_object = JSON.parse( IO.read(filename, encoding:'utf-8') )

my_object.keys.each do |obj|
  my_object[obj]["secure_search"] = secured_url(obj, my_object[obj]["color"])
end

my_object.each do |_,v|
  my_object[obj]["secure_search"] = secured_url(v['name'], v["color"])
  my_object[v['name']]['amazon'] = process_secure(v['name']['secure_search'])
end

File.open("amz_test.json",'w') do |s|
  s.puts my_object.to_json
end
