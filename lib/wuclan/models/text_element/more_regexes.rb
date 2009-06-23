
# http://github.com/Empact/html_test/tree/master
# http://github.com/michaeledgar/validates_not_profane
#
# http://github.com/porras/livevalidation/tree/master
#   Rails plugin which allows automatic integration of your Rails application with Javascript library LiveValidation. This library implements client-side form validation and you can
#
# http://github.com/cainlevy/semantic-attributes
#
# git://github.com/alexdunae/validates_email_format_of.git
#   Validate e-mail addreses against RFC 2822 and RFC 3696 with this popular Ruby on Rails plugin and gem.
#
# http://github.com/freelancing-god/active-matchers/tree/master
#   Helpful rspec matchers for testing validations and associations.
#
# http://github.com/redinger/validation_reflection/tree/master
#  refl = Person.reflect_on_validations_for(:name)
#  refl[0].macro
#  => :validates_presence_of
#
# http://github.com/augustl/live-validations/tree/master
#   Reads Active Record's validations and makes them available to live client side javascript validation scripts
#
# http://github.com/adzap/validates_timeliness/tree/master
#   Date and time validation plugin for Rails 2.x and allows custom date/time formats

# http://github.com/matthewrudy/regexpert/tree/master
#   Description:        A collection of common Regexps for Ruby. Validation for emails, uk postcode, etc.
#

# http://plugins.jquery.com/project/validate
#
#

# ===========================================================================
#
# # http://github.com/matthewrudy/regexpert/blob/master/lib/regexpert.rb
#
#   module Format
#     # This is taken from dm-more - http://github.com/sam/dm-more/tree/master/dm-validations/lib/dm-validations/formats/email.rb
#     # RFC2822 (No attribution reference available)
#     #
#     # doctest: email_address
#     # >> "MatthewRudyJacobs@gmail.com" =~ Regexpert::Format::EmailAddress
#     # => 0
#     #
#     # >> "dev@" =~ Regexpert::Format::EmailAddress
#     # => nil
#     #
#     EmailAddress = begin
#       alpha = "a-zA-Z"
#       digit = "0-9"
#       atext = "[#{alpha}#{digit}\!\#\$\%\&\'\*+\/\=\?\^\_\`\{\|\}\~\-]"
#       dot_atom_text = "#{atext}+([.]#{atext}*)*"
#       dot_atom = "#{dot_atom_text}"
#       qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
#       text = "[\\x01-\\x09\\x11\\x12\\x14-\\x7f]"
#       quoted_pair = "(\\x5c#{text})"
#       qcontent = "(?:#{qtext}|#{quoted_pair})"
#       quoted_string = "[\"]#{qcontent}+[\"]"
#       atom = "#{atext}+"
#       word = "(?:#{atom}|#{quoted_string})"
#       obs_local_part = "#{word}([.]#{word})*"
#       local_part = "(?:#{dot_atom}|#{quoted_string}|#{obs_local_part})"
#       no_ws_ctl = "\\x01-\\x08\\x11\\x12\\x14-\\x1f\\x7f"
#       dtext = "[#{no_ws_ctl}\\x21-\\x5a\\x5e-\\x7e]"
#       dcontent = "(?:#{dtext}|#{quoted_pair})"
#       domain_literal = "\\[#{dcontent}+\\]"
#       obs_domain = "#{atom}([.]#{atom})*"
#       domain = "(?:#{dot_atom}|#{domain_literal}|#{obs_domain})"
#       addr_spec = "#{local_part}\@#{domain}"
#       pattern = /^#{addr_spec}$/
#     end
#
#     # This is taken from dm-more http://github.com/sam/dm-more/tree/master/dm-validations/lib/dm-validations/formats/url.rb
#     # Regex from http://www.igvita.com/2006/09/07/validating-url-in-ruby-on-rails/
#     #
#     # doctest: url # examples from Rails auto_link tests
#     # >> "http://www.rubyonrails.com/contact;new" =~ Regexpert::Format::Url
#     # => 0
#     # >> "http://maps.google.co.uk/maps?f=q&q=the+london+eye&ie=UTF8&ll=51.503373,-0.11939&spn=0.007052,0.012767&z=16&iwloc=A" =~ Regexpert::Format::Url
#     # => 0
#     # >> "http://en.wikipedia.org/wiki/Sprite_(computer_graphics)" =~ Regexpert::Format::Url
#     # => 0
#     # TODO: think of a good example of a bad url
#     Url = begin
# /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
#     end
#
#     # This is taken from Django.Contrib.Localflavor.uk
#     # The regular expression used is sourced from the schema for British Standard
#     # BS7666 address types: http://www.govtalk.gov.uk/gdsc/schemas/bs7666-v2-0.xsd
#     #
#     # doctest: ukpostcode
#     # >> "GIR 0AA" =~ Regexpert::Format::UKPostcode # GIR 0AA is a special GIRO postcode
#     # => 0
#     # >> "AL40XB" =~ Regexpert::Format::UKPostcode
#     # => 0
#     # >> "CB4 1TL" =~ Regexpert::Format::UKPostcode
#     # => 0
#     #
#     # >> "AL44 NOP" =~ Regexpert::Format::UKPostcode
#     # => nil
#     # >> "CB4-1TL" =~ Regexpert::Format::UKPostcode
#     # => nil
#     #
#     UKPostcode = begin
#       outcode_pattern = '[A-PR-UWYZ]([0-9]{1,2}|([A-HIK-Y][0-9](|[0-9]|[ABEHMNPRVWXY]))|[0-9][A-HJKSTUW])'
#       incode_pattern = '[0-9][ABD-HJLNP-UW-Z]{2}'
#       postcode_regex = Regexp.new("^(GIR *0AA|#{outcode_pattern} *#{incode_pattern})$", Regexp::IGNORECASE)
#     end


# ===========================================================================
#
# http://www.botvector.net/2008/05/regular-expression-samples.html
#
#
# //Address: State code (US)
# '/\\b(?:A[KLRZ]|C[AOT]|D[CE]|FL|GA|HI|I[ADLN]|K[SY]|LA|M[ADEINOST]|N[CDEHJMVY]|O[HKR]|PA|RI|S[CD]|T[NX]|UT|V[AT]|W[AIVY])\\b/'
#
# //Address: ZIP code (US)
# '\b[0-9]{5}(?:-[0-9]{4})?\b'
#
# //Credit card: All major cards
# '^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6011[0-9]{12}|3(?:0[0-5]|[68][0-9])[0-9]{11}|3[47][0-9]{13})$'
#
# //Credit card: American Express
# '^3[47][0-9]{13}$'
#
# //Credit card: Diners Club
# '^3(?:0[0-5]|[68][0-9])[0-9]{11}$'
#
# //Credit card: Discover
# '^6011[0-9]{12}$'
#
# //Credit card: MasterCard
# '^5[1-5][0-9]{14}$'
#
# //Credit card: Visa
# '^4[0-9]{12}(?:[0-9]{3})?$'
#
# //Credit card: remove non-digits
# '/[^0-9]+/'
#
# //Date d/m/yy and dd/mm/yyyy
# //1/1/00 through 31/12/99 and 01/01/1900 through 31/12/2099
# //Matches invalid dates such as February 31st
# '\b(0?[1-9]|[12][0-9]|3[01])[- /.](0?[1-9]|1[012])[- /.](19|20)?[0-9]{2}\b'
#
# //Date dd/mm/yyyy
# //01/01/1900 through 31/12/2099
# //Matches invalid dates such as February 31st
# '(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)[0-9]{2}'
#
# //Date m/d/y and mm/dd/yyyy
# //1/1/99 through 12/31/99 and 01/01/1900 through 12/31/2099
# //Matches invalid dates such as February 31st
# //Accepts dashes, spaces, forward slashes and dots as date separators
# '\b(0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)?[0-9]{2}\b'
#
# //Date mm/dd/yyyy
# //01/01/1900 through 12/31/2099
# //Matches invalid dates such as February 31st
# '(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)[0-9]{2}'
#
# //Date yy-m-d or yyyy-mm-dd
# //00-1-1 through 99-12-31 and 1900-01-01 through 2099-12-31
# //Matches invalid dates such as February 31st
# '\b(19|20)?[0-9]{2}[- /.](0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])\b'
#
# //Date yyyy-mm-dd
# //1900-01-01 through 2099-12-31
# //Matches invalid dates such as February 31st
# '(19|20)[0-9]{2}[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])'
#
#
# //IP address
# //Matches 0.0.0.0 through 999.999.999.999
# //Use this fast and simple regex if you know the data does not contain invalid IP addresses.
# '\b([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\b'
#
# //IP address
# //Matches 0.0.0.0 through 999.999.999.999
# //Use this fast and simple regex if you know the data does not contain invalid IP addresses,
# //and you don't need access to the individual IP numbers.
# '\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'
#
# //IP address
# //Matches 0.0.0.0 through 255.255.255.255
# //Use this regex to match IP numbers with accurracy, without access to the individual IP numbers.
# '\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'
#
# //IP address
# //Matches 0.0.0.0 through 255.255.255.255
# //Use this regex to match IP numbers with accurracy.
# //Each of the 4 numbers is stored into a capturing group, so you can access them for further processing.
# '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'
#
#
# //Number: Currency amount
# //Optional thousands separators; optional two-digit fraction
# '\b[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?\b'
#
# //Number: Currency amount
# //Optional thousands separators; mandatory two-digit fraction
# '\b[0-9]{1,3}(?:,?[0-9]{3})*\.[0-9]{2}\b'
#
# //Number: floating point
# //Matches an integer or a floating point number with mandatory integer part.  The sign is optional.
# '[-+]?\b[0-9]+(\.[0-9]+)?\b'
#
# //Number: floating point
# //Matches an integer or a floating point number with optional integer part.  The sign is optional.
# '[-+]?\b[0-9]*\.?[0-9]+\b'
#
# //Number: hexadecimal (C-style)
# '\b0[xX][0-9a-fA-F]+\b'
#
# //Number: Insert thousands separators
# //Replaces 123456789.00 with 123,456,789.00
# '(?<=[0-9])(?=(?:[0-9]{3})+(?![0-9]))'  //Number: integer //Will match 123 and 456 as separate integer numbers in 123.456 '\b\d+\b'  //Number: integer //Does not match numbers like 123.456 '(?
#
# Passwords
#
#
# //Password complexity
# //Tests if the input consists of 6 or more letters, digits, underscores and hyphens.
# //The input must contain at least one upper case letter, one lower case letter and one digit.
# '\A(?=[-_a-zA-Z0-9]*?[A-Z])(?=[-_a-zA-Z0-9]*?[a-z])(?=[-_a-zA-Z0-9]*?[0-9])[-_a-zA-Z0-9]{6,}\z'
#
# //Password complexity
# //Tests if the input consists of 6 or more characters.
# //The input must contain at least one upper case letter, one lower case letter and one digit.
# '\A(?=[-_a-zA-Z0-9]*?[A-Z])(?=[-_a-zA-Z0-9]*?[a-z])(?=[-_a-zA-Z0-9]*?[0-9])\S{6,}\z'
#
# //Path: Windows
# '\b[a-z]:\\[^/:*?"<>|\r\n]*'
#
# //Path: Windows
# //Different elements of the path are captured into backreferences.
# '\b((?#drive)[a-z]):\\((?#folder)[^/:*?"<>|\r\n]*\\)?((?#file)[^\\/:*?"<>|\r\n]*)'
#
# //Path: Windows or UNC
# '(?:(?#drive)\b[a-z]:|\\\\[a-z0-9]+)\\[^/:*?"<>|\r\n]*'
#
# //Path: Windows or UNC
# //Different elements of the path are captured into backreferences.
# '((?#drive)\b[a-z]:|\\\\[a-z0-9]+)\\((?#folder)[^/:*?"<>|\r\n]*\\)?((?#file)[^\\/:*?"<>|\r\n]*)'

# //Phone Number (North America)
# //Matches 3334445555, 333.444.5555, 333-444-5555, 333 444 5555, (333) 444 5555 and all combinations thereof.
# //Replaces all those with (333) 444-5555
# preg_replace('\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})', '(\1) \2-\3', $text);
#
# //Phone Number (North America)
# //Matches 3334445555, 333.444.5555, 333-444-5555, 333 444 5555, (333) 444 5555 and all combinations thereof.
# '\(?[0-9]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}'


# Postal codes
#
#
# //Postal code (Canada)
# '\b[ABCEGHJKLMNPRSTVXY][0-9][A-Z] [0-9][A-Z][0-9]\b'
#
# //Postal code (UK)
# '\b[A-Z]{1,2}[0-9][A-Z0-9]? [0-9][ABD-HJLNP-UW-Z]{2}\b'
#

#
# Programming
#
# //Programming: GUID
# //Microsoft-style GUID, numbers only.
# '[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}'
#
# //Programming: GUID
# //Microsoft-style GUID, with optional parentheses or braces.
# //(Long version, if your regex flavor doesn't support conditionals.)
# '[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}|\([A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}\)|\{[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}\}'
#
# //Programming: GUID
# //Microsoft-style GUID, with optional parentheses or braces.
# //Short version, illustrating the use of regex conditionals.  Not all regex flavors support conditionals.
# //Also, when applied to large chunks of data, the regex using conditionals will likely be slower
# //than the long version.  Straight alternation is much easier to optimize for a regex engine.
# '(?:(\()|(\{))?[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}(?(1)\))(?(2)\})'
#
# //Programming: Remove escapes
# //Remove backslashes used to escape other characters
# preg_replace('\\(.)', '\1', $text);
#
# //Programming: String
# //Quotes may appear in the string when escaped with a backslash.
# //The string may span multiple lines.
# '"[^"\\]*(?:\\.[^"\\]*)*"'

#
# Escape
#
# //Regex: Escape metacharacters
# //Place a backslash in front of the regular expression metacharacters
# gsub("[][{}()*+?.\\^$|]", "\\$0", $text);



        # 3530588    3.4G /workspace/data lab13
        # 2242028    2.2G /workspace/data lab17
        # 3530588    3.4G /workspace/data lab16
        # 3530588    3.4G /workspace/data lab21
        # 3530588    3.4G /workspace/data lab14
        #       4    4.0K /workspace/data lab12
        # 3530588    3.4G /workspace/data lab15
        #      20     20K /workspace/data lab23



# Security
#
#
# //Security: ASCII code characters excl. tab and CRLF
# //Matches any single non-printable code character that may cause trouble in certain situations.
# //Excludes tabs and line breaks.
# '[\x00\x08\x0B\x0C\x0E-\x1F]'
#
# //Security: ASCII code characters incl. tab and CRLF
# //Matches any single non-printable code character that may cause trouble in certain situations.
# //Includes tabs and line breaks.
# '[\x00-\x1F]'
#
# //Security: Escape quotes and backslashes
# //E.g. escape user input before inserting it into a SQL statement
# gsub("\\$0", "\\$0", $text);
#
# //Security: Unicode code and unassigned characters excl. tab and CRLF
# //Matches any single non-printable code character that may cause trouble in certain situations.
# //Also matches any Unicode code point that is unused in the current Unicode standard,
# //and thus should not occur in text as it cannot be displayed.
# //Excludes tabs and line breaks.
# '[^\P{C}\t\r\n]'
#
# //Security: Unicode code and unassigned characters incl. tab and CRLF
# //Matches any single non-printable code character that may cause trouble in certain situations.
# //Also matches any Unicode code point that is unused in the current Unicode standard,
# //and thus should not occur in text as it cannot be displayed.
# //Includes tabs and line breaks.
# '\p{C}'
#
# //Security: Unicode code characters excl. tab and CRLF
# //Matches any single non-printable code character that may cause trouble in certain situations.
# //Excludes tabs and line breaks.
# '[^\P{Cc}\t\r\n]'
#
# //Security: Unicode code characters incl. tab and CRLF
# //Matches any single non-printable code character that may cause trouble in certain situations.
# //Includes tabs and line breaks.
# '\p{Cc}'
#
#
#
# SSN (Social security numbers)
#
#
# //Social security number (US)
# '\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b'




