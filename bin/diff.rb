#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'
require 'pry'

# Restrict to only current members
# TODO: update the SPARQL to include all in the current term instead
class Comparison < EveryPoliticianScraper::NulllessComparison
  def external
    super.delete_if { |row| row[:end_date] }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff

puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
