class Beagle

	BEAGLE_NIL = '(null)'

	class << self

		def total_time
			@@total_time
		end	
		def first_hit
			@@first_hit
		end
		def number_of_hits
			@@number_of_hits
		end
	
		def find query, extension = nil
#			puts "query: \"#{query}\" extension: nil"
 
			return [] if query.nil? or query.empty?
			query.strip!
			return [] if query.empty? or query.length == 1 or query[0..1] == '--'

			lines = `beagle-query --verbose #{query}`[3..-1]
			results = []
			@@first_hit = 0.0
			@@total_time = 0.0
			@@number_of_hits = 0
			unless lines.nil?
				results = parse_results lines
			end
			return results
		end

		def parse_results lines
			hits = []
			item = nil
			lines.each { |line|
				if line.starts_with? 'First hit returned in '
					# Erste Zeile - Anfragedauer
					@@first_hit = line[22..-2].strip.sub(/,/, '.').to_f

				# Ende der Ausgabe - Statistik
				# 
				elsif line.starts_with? 'Elapsed time: '
					# Vorletzte Zeile - Dauer der gesamten Anfrage
					@@total_time = line[14..-2].strip.sub(/,/, '.').to_f
				elsif line.starts_with? 'Total hits: '
					# Letzte Zeile - Anzahl der Treffer
					@@number_of_hits = line[12..-1].to_i


				# Behandlung der einzelnen Elemente
				# 
				elsif line.starts_with? '  Uri: '
					# Neuer Eintrag - neues Item alles frisch
					item = Item.new
					item.divers = {}
					item.uri = line[7..-1]

				elsif line.starts_with? ' Snip: '
					if line[7..-1].strip != BEAGLE_NIL
						item.snip = line[7..-1]
					end
                                elsif line.starts_with? 'PaUri: '
                                        if line[7..-1].strip != BEAGLE_NIL
                                                item.pa_uri = line[7..-1]
                                        end
				elsif line.starts_with? ' Type: '
					if line[7..-1].strip != BEAGLE_NIL
						item.type = line[7..-1] 
					end
				elsif line.starts_with? 'MimeT: '
					if line[7..-1].strip != BEAGLE_NIL
						item.mime_type = line[7..-1] 
					end
				elsif line.starts_with? '  Src: '
					if line[7..-1].strip != BEAGLE_NIL
						item.source = line[7..-1] 
					end
				elsif line.starts_with? 'Score: '
					if line[7..-1].strip != BEAGLE_NIL
						item.score = line[7..-1].sub(/,/, '.').to_f 
					end
				elsif line.starts_with? ' Time: '
					if line[7..-1].strip != BEAGLE_NIL
						# Format: 23.03.2006 17:44:19
						date, time = line[7..-1].split " "
						day, month, year = date.split "."
						hour, minute, second = time.split ":"
						item.time = Time.local year, month, day, hour, minute, second
					end

				elsif line == "\n"
					# Ende eines Eintrags - speicher alles in den Ergebnis-Array
					hits << item
				
				else
					# Unbekannte Zeile - spezielle Felder je nach Typ
					begin
						type, key_value = line.split( ':', 2 )
						type = type.strip.underscore.to_sym
						item.divers[type] = {} if item.divers[type].nil?
						key, value = key_value.split( ' = ', 2 ) 
						item.divers[type][key.strip.underscore.to_sym] = value
					rescue
						# no need to get excited - this was probably a beagle exception
					end
				end
			}
			return hits
		end
	end
end
