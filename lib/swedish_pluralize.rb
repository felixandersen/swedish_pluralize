module SwedishPluralize
  def self.inflections_plural(i)
    # declination 1 -or
    i.plural /a$/i, 'or' # flicka, flickor
    i.plural /s$/i, 'sor' #ros, rosor

    # declination 2 -ar
    i.plural /([^r][^r]|rr)e$/i, '\1ar' # pojke, pojkar, (not spridare, spridare but aborre, abborrar)
    i.plural /g$/i, 'gar'
    i.plural /el$/i, 'ar' # fågel, fåglar
    i.plural /l$/i, 'lar' # bil, bilar
    i.plural /app$/i, 'appar' #lapp, lappar

    # declination 3 -er
    i.plural /([tmnlr])$/i, '\1er' # produkt, produkter
    i.plural /upp$/i, 'upper'
    i.plural /([^o])s$/i, '\1ser'
    i.plural /([^p])p$/i, '\1per'
    
    i.plural /kel$/i, 'kler' # muskel, muskler
    i.plural /tel$/i, 'tlar' # titel, titlar

    # declination 4 -r
    i.plural /de$/i, 'der' # fiende, fiender

    # declination 5 -n
    i.plural /le$/i, 'lem' # muskel, muskler
    i.plural /de$/i, 'den' # åliggande, åliggander
    
    i.plural /([^bd])ag$/i, '\1ag' #landslag, landslag
    i.plural /([de])lag$/i, '\1lagar' #grundlag, grundlagar
    
    i.plural /iende$/i, 'iender' # fiende, fiender
    i.plural /(i|än)de$/i, '\1der' # guide, guider, frände, fränder

    i.plural /ö$/i, 'ön' #frö, frön
    i.plural /ok$/i, 'öcker' #bok, böcker
    i.plural /um$/i, 'a' #faktum, fakta
    i.plural /o$/i, 'or' #sko, skor
    i.plural /and$/i, 'änder' #hand, händer

    i.plural /man$/i, 'män' #man, män
    i.plural /mus$/i, 'möss' #mus, möss
    i.plural /([^n])d$/i, '\1den' #huvud, huvuden, but should let lund and such through 
    i.plural /ne$/i, 'nen' #vittne, vittnen

    # Own hack
    i.plural /([^l])ie?$/i, '\1ier' #kategori, kategorier - aktie, aktier
    i.plural /i$/i, 'ier' #kategori, kategorier
    
    # i.plural /(^.+)del$/i, '\1dlar' #sedel, sedlar and bödel, bödlar but NOT del, delar
    # i.plural /^å$/i, 'åar' #å, åar
    # i.plural /are$/i, 'are' #åklagare, härförare och A-lagare
    # i.plural /é$/i, 'éer' #idé, idéer
    # i.plural /nting/i, 'nting' #mellanting
    # i.plural /([ngj])em([åäa])ng$/i, '\1em\2ng' #abonemang, arrangemang, handgemäng
    #i.plural /ns$/i, 'nser' #konduktans, konduktanser
  end

  def self.inflections_singular(i)
    # declination 1 -or
    i.singular /or$/i, 'a' # flicka, flickor

    # declination 2 -ar
    i.singular /kar$/i, 'ke' # pojke, pojkar
    i.singular /gar$/i, 'g'
    i.singular /glar$/i, 'gel' # fågel, fåglar
    i.singular /lar$/i, '' # bil, bilar

    # declination 3 -er
    i.singular /([tmnslpr])er$/i, '\1' # produkt, produkter
    i.singular /ler$/i, 'el' # muskel, muskler

    # declination 4 -r
    i.singular /der$/i, 'de' # fiende, fiender

    # declination 5 -n
    i.singular /kler$/i, 'kel' # muskel, muskler
    i.singular /tlar$/i, 'tel' # titel, titlar

    i.singular /en$/i, 'e' #vittne, vittnen
    i.singular /ön$/i, 'ö' #frö, frön
    i.singular /öcker$/i, 'ok' #bok, böcker
    i.singular /a$/i, 'um' #faktum, fakta
    i.singular /män$/i, 'man' #man, män
    i.singular /möss$/i, 'mus' #mus, möss
    i.singular /den$/i, 'd' #huvud, huvuden
    i.singular /kor$/i, 'ko' #sko, skor
    i.singular /änder$/i, 'and' #hand, händer
    i.singular /sor$/i, 's' #ros, rosor

    #untouchable endings
    i.singular /dagis$/i, 'dagis'
    i.singular /bevis$/i, 'bevis'
    i.singular /paradis$/i, 'paradis'
  end

  def self.inflections_uncountable(i)
    i.uncountable %w(hus kar träd får brev namn nummer kön dualis fritis pris kondis lekis pluralis ris singularis)
  end

  def self.inflections_irregular(i)
  end

  def self.ordinalize(number)
    if (11..12).include?(number.to_i % 100)
      "#{number}:e"
    else
      case number.to_i % 10
      when 1: "#{number}:a"
      when 2: "#{number}:a"
      else    "#{number}:e"
      end
    end
  end

  class Inflections < ::ActiveSupport::Inflector::Inflections
  end

  def self.inflections
    if block_given?
      yield Inflections.instance
    else
      Inflections.instance
    end
  end

  def self.pluralize(word)
    result = word.to_s.dup
    if inflections.uncountables.include?(result.downcase)
      result
    else
      inflections.plurals.each do |(rule, replacement)|
        break if result.gsub!(rule, replacement)
      end
      result
    end
  end
end

SwedishPluralize.inflections do |i|
  SwedishPluralize::inflections_plural(i)
  SwedishPluralize::inflections_singular(i)
  SwedishPluralize::inflections_irregular(i)
  SwedishPluralize::inflections_uncountable(i)
end
