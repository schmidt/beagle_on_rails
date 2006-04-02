#!/usr/bin/env ruby

$: << File.dirname(__FILE__) + '/../../lib'

require 'i18nservice'
require 'i18nconfig'



class Duck
  def talk
    puts _('I talk like a duck')
    puts _('Quack Quack !!')
  end
  def walk
    puts _('I walk like a duck')
  end
  def eat_worms
    0.upto(4) do |i|
      puts n_('I ate %i worm', 'I ate %i worms', i)
    end
  end
  def live
    talk
    walk
    eat_worms
  end
end

duck = Duck.new

duck.live

puts "----------- I18nService.instance.lang = 'fr' ----------------------"
I18nService.instance.lang = 'fr'

duck.live

