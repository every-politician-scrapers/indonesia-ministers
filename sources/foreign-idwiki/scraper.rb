#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Kabinet'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img color name kabinet start end].freeze
    end

    def tds
      noko.css('th,td')
    end

    def empty?
      tds[4].text == tds[5].text
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
