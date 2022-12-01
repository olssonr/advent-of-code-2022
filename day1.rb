# frozen_string_literal: true

# This returns something like [[1000, 2000, 3000], [4000], [5000, 6000], [7000, 8000, 9000], [10000]]
# Where each element in the array is an array of calorie numbers
elf_inventory_list = (File.readlines 'day1_puzzle_input.txt').join.split("\n\n").map { |x| x.split("\n").map(&:to_i) }
elf_total_calories_list = elf_inventory_list.map(&:sum)


elf_with_most_calories = elf_total_calories_list.max
puts "Part 1: #{elf_with_most_calories}"

top_three_elfs_calories = elf_total_calories_list.sort.reverse.take(3).sum
puts "Part 2: #{top_three_elfs_calories}"