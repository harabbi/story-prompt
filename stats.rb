require 'json'

HISTORY_FILE = 'history.txt'.freeze

unless File.exists?(HISTORY_FILE)
	puts "Come on bro! You know there's nothing here..."
	exit(1)
end

def alphabetical_first_and_last(data)
	puts "  First Alphabetical Entered: #{data.keys.sort.first}"
	puts "  Last Alphabetical Entered: #{data.keys.sort.last}"
end

def least_and_most_used(data)
	tuples = data.to_a.sort_by{ |key, count| count }
	puts "  Least Entered: #{tuples.first.first} (#{tuples.first.last} times)"
	puts "  Most Entered: #{tuples.last.first} (#{tuples.last.last} times)"
end
def shortest_and_longest_words(data)
	puts "  Shortest Entered: #{data.keys.sort_by(&:length).first}"
	puts "  Longest Entered: #{data.keys.sort_by(&:length).last}"
end

count = 0
min = nil
max = nil
stats = {}

keys = [:units, :places, :adjectives, :nouns]
keys.each do |key|
	stats[key] = {}
end

IO.readlines(HISTORY_FILE, chomp: true).each do |line|
	count += 1

	num, *parts = line.split(',')

	num = num.to_i
	min = num if min.nil? || num < min
	max = num if max.nil? || num > max

	keys.each_with_index do |key, idx|
		val = parts[idx]
		stats[key][val] ||= 0
		stats[key][val] += 1
	end
end

puts "The walks numbers vary between #{min} and #{max} across #{count} trips!"
keys.each do |key|
	puts "\n#{key}"
	least_and_most_used(stats[key])
	shortest_and_longest_words(stats[key])
	alphabetical_first_and_last(stats[key])
end
