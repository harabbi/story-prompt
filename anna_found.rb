require 'json'

if ARGV.length != 1
	puts 'Usage: ruby anna_found.rb \'{ "NUMBER": "1", "UNIT_OF_MEASURE": "mile", "PLACE": "work", "ADJECTIVE": "blue", "NOUN": "rock" }\''
	exit(1)
end

TEMPLATE = 'One day Anna was walking her %d %s commute to %s and found a %s %s on the ground.'

json = JSON.parse(ARGV.first)

errors = []


unless json['NUMBER'].to_i > 0
	errors.push 'NUMBER is invalid'
end

['UNIT_OF_MEASURE', 'PLACE', 'ADJECTIVE', 'NOUN'].each do |key|
	if !json.key?(key)
		errors.push "#{key} is missing!"
	elsif json[key] !~ /\w{1,25}/
		errors.push "#{key} is invalid: Must be a single word up to 25 characters"
	end
end


if errors.any?
	puts errors
	exit(1)
end

puts TEMPLATE % [json['NUMBER'], json['UNIT_OF_MEASURE'], json['PLACE'], json['ADJECTIVE'], json['NOUN']]

File.open('history.txt', 'a+') do |file|
	file.write [json['NUMBER'], json['UNIT_OF_MEASURE'], json['PLACE'], json['ADJECTIVE'], json['NOUN']].join(',')
	file.write "\n"
end
