#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'yaml'

files = ARGV.empty? ? Dir.glob('content/posts/**/*.md').sort : ARGV
errors = []

def parse_yaml(source, path, line, context, errors)
  YAML.safe_load(source, permitted_classes: [Date, Time], aliases: true)
rescue Psych::Exception => e
  errors << "#{path}:#{line}: invalid YAML in #{context}: #{e.message}"
end

files.each do |path|
  text = File.read(path)
  lines = text.lines

  if lines.first&.chomp == '---'
    close_index = lines[1..]&.find_index { |line| line.chomp == '---' }
    if close_index
      front_matter = lines[1, close_index].join
      parse_yaml(front_matter, path, 1, 'front matter', errors)
    else
      errors << "#{path}:1: unclosed front matter"
    end
  end

  fence = nil
  block = []

  lines.each_with_index do |line, index|
    line_number = index + 1

    if fence
      if line.start_with?(fence[:marker])
        if %w[yaml yml].include?(fence[:language])
          parse_yaml(block.join, path, fence[:line], 'fenced code block', errors)
        end
        fence = nil
        block = []
      else
        block << line
      end
      next
    end

    match = line.match(/\A(`{3,}|~{3,})\s*([^\s`]*)?/)
    next unless match

    fence = {
      marker: match[1],
      language: match[2].to_s.downcase,
      line: line_number
    }
  end

  errors << "#{path}:#{fence[:line]}: unclosed fenced code block" if fence
end

if errors.any?
  warn errors.join("\n")
  exit 1
end

puts "Validated #{files.length} Markdown files"
