#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      tds[3].text.tidy
    end

    def position
      tds[1].text.tidy
    end

    field :start_date do
      Date.parse(start_text)
    end

    field :end_date do
      Date.parse(end_text) rescue nil
    end

    private

    def tds
      noko.css('td')
    end

    def start_text
      tds[4].text.tidy
    end

    def end_text
      tds[5].text.tidy
    end
  end

  class Members
    def member_items
      # the position column is left blank in the case of a replacement,
      # so need to get it from the previous row
      (raw = super.map(&:to_h)).each_cons(2) do |one, two|
        if two[:position].empty?
          two[:position] = one[:position]
          one[:end_date] ||= '???'
        end
        one[:position] = one[:position].split('/')
      end
      raw
    end

    def members
      super + presidents
    end

    def member_container
      noko.css('.wikitable')[1].xpath('.//tr[td]')
    end

    def presidents
      [
        { name: president_and_vp.first, start_date: nil, end_date: nil, position: 'President' },
        { name: president_and_vp.last,  start_date: nil, end_date: nil, position: 'Vice President' }
      ]
    end

    def president_and_vp
      noko.css('.wikitable')[0].xpath('.//tr[td]//td').map(&:text).reject(&:empty?)
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
