case I18nService.instance.plural_family
	when :one
  def plural_form(n)
		0
	end
	when :two_germanic
	def plural_form(n)
		n == 1 ? 0 : 1
	end
	when :two_romanic
	def plural_form(n)
		n > 1 ? 1 : 0
	end
#TODO: testing of followin forms
	when :three_celtic
	def plural_form(n)
		n==1 ? 0 : n==2 ? 1 : 2
	end
	when :three_slavic_russian
	def plural_form(n)
		n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2
	end
	when :three_baltic_latvian
	def plural_form(n)
		n%10==1 && n%100!=11 ? 0 : n != 0 ? 1 : 2
	end
	when :three_baltic_lithuanian
	def plural_form(n)
		n%10==1 && n%100!=11 ? 0 : n%10>=2 && (n%100<10 || n%100>=20) ? 1 : 2
	end
	when :three_slavic_polish
	def plural_form(n)
		n==1 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2
	end
	when :four
	def plural_form(n)
		n%100==1 ? 0 : n%100==2 ? 1 : n%100==3 || n%100==4 ? 2 : 3
	end
end
