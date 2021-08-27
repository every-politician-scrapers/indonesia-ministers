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
      (raw = super.map(&:to_h)).each_with_index do |mem, index|
        mem[:position] = raw[index - 1][:position] if mem[:position].empty?
        mem[:position] = [mem[:position]].flatten.map { |posn| posn.split('/').map(&:tidy) }
      end
    end

    def member_container
      noko.css('.wikitable')[1].xpath('.//tr[td]')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
