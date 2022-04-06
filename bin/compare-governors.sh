#!/bin/bash

bundle exec ruby bin/scraper/governors-wikipedia.rb > data/governors-wikipedia.csv
bundle exec ruby bin/diff-governors.rb | ifne tee data/diff-governors.csv
