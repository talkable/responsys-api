require "i18n"

I18n.load_path << File.expand_path("../responsys/i18n/en.yml", __FILE__)
I18n.locale = :en
I18n.enforce_available_locales = false

require "responsys/exceptions/all"
require "responsys/helper"
require "responsys/configuration"
require "responsys/api/client"
require "responsys/member"
require "responsys/repository"
