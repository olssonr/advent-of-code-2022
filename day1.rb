# frozen_string_literal: true

# This returns something like [[1000, 2000, 3000], [4000], [5000, 6000], [7000, 8000, 9000], [10000]]
# Where each element in the array is an array of calorie numbers
elf_inventories = (File.readlines 'day1_puzzle_input.txt').join.split("\n\n").map { |x| x.split("\n").map(&:to_i) }
elf_with_most_calories = elf_inventories.map(&:sum).max

puts "Part1: #{elf_with_most_calories}"