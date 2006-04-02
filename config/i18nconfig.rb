# lets go unicode, you will get less trouble
$KCODE = 'u'
# The directory where translation files (PO files) will go
I18nService.instance.po_dir = File.dirname(__FILE__) + '/po'

module ActionView
module Helpers
module DateHelper

def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
	from_time = from_time.to_time if from_time.respond_to?(:to_time)
	to_time = to_time.to_time if to_time.respond_to?(:to_time)
	distance_in_minutes = (((to_time - from_time).abs)/60).round
	distance_in_seconds = ((to_time - from_time).abs).round

	case distance_in_minutes
		when 0..1
			return (distance_in_minutes==0) ? _('less than a minute') : "1 #{_('minute')}" unless include_seconds
			case distance_in_seconds
				when 0..5   then s = 5;  _i('less than #{s} seconds')
				when 6..10  then s = 10; _i('less than #{s} seconds')
				when 11..20 then s = 20; _i('less than #{s} seconds')
				when 21..40 then _('half a minute')
				when 41..59 then _('less than a minute')
				else             "1 #{_('minute')}"
			end

		when 2..45      then "#{distance_in_minutes} #{_('minutes')}"
		when 46..90     then "#{_('about')} 1 #{_('hour')}"
		when 90..1440   then "#{_('about')} #{(distance_in_minutes.to_f / 60.0).round} #{_('hours')}"
		when 1441..2880 then "1 #{_('day')}"
		else                 "#{(distance_in_minutes / 1440).round} #{_('days')}"
	end
end

end
end
end
