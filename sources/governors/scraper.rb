#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath('//table[.//tr[contains(., "Foto")]]//tr[td]')
    end
  end

  class Member
    field :id do
      tds[3].css('a/@wikidata').map(&:text).first
    end

    field :name do
      tds[3].css('a').map(&:text).first
    end

    field :province do
      tds[0].css('a/@wikidata').text
    end

    field :provinceLabel do
      tds[0].css('a').text
    end

    field :position do
    end

    field :positionLabel do
      "Governor of #{provinceLabel}"
    end

    field :startDate do
      WikipediaDate::Indonesian.new(tds[7].text.tidy).to_s rescue binding.pry
    end

    private

    def tds
      noko.css('td')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
