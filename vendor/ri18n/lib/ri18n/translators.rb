#!/usr/bin/env ruby

i18n = I18nService.instance

# Returns the translated +string+ if available; otherwise returns +string+
def _(string)
  fetch = I18nService.instance.table.fetch(string, string) 
  fetch.empty? ? string : fetch
end

# Returns the translated +string+ if available; otherwise returns +string+
# Does #{} interpolation on the tranlated string
def _i(string, caller = self)
  ret = I18nService.instance.table.fetch(string, string) || string
  ret.interpolate(caller)
end

# Returns a translated +msgid+ in the proper plural form.
# +n+ is the number (should be an Integer) that determines the plural form
# Typical usage:
#     n_('%i file', '%i files', n)
# An implicit +sprintf+ is made to substitute %i with the value of n.

def n_(msgid, msgid_plural, n)
  ret = I18nService.instance.table[msgid]
	unless ret.empty? 
		sprintf(ret.plurals[plural_form(n)], n)
  else
		sprintf(n == 1 ? msgid : msgid_plural, n)
	end
end

unless i18n.try_load
  i18n.table = {}
# Default translator used in case where no catalog is loaded.
# it just returns the unchanged +string+
  def _(string)
    string
  end

# Default translator with interpolation used in case where no catalog is loaded.
# It returns the interpolated +string+
  def _i(string, caller = self)
    string.interpolate(caller)
  end

# Default plural translator used in case where no catalog is loaded.
# it returns the msgid if <tt>n == 1</tt> and msgid_plural otherwise
# (i.e. 'germanic' type plural form like for 'de' or 'en')
	def n_(msgid, msgid_plural, n)
		sprintf(n == 1 ? msgid : msgid_plural, n)
	end
end