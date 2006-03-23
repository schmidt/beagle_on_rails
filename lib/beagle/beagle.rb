class Beagle

	class << self
		def find query, extension = nil
			puts "query: \"#{query}\" extension: nil"
 
			return [] if query.nil? or query.empty?
			query.strip!
			return [] if query.empty? or query.length == 1 or query[0..1] == '--'

			lines = `beagle-query #{query}`[3..-1]
			results = []
			unless lines.nil?
				lines.split.each do |line|
					i = Item.new
					i.uri = line
					results << i
				end
			end
			return results
		end
	end
end
