1:
	ruby 1.sum.rb < day-1-input.txt
2:
	ruby 2.cubes.rb < day-2-input.txt
3:
	ruby 3.part_numbers.rb < day-3-input.txt
3_test:
	echo "467..114..\n...*......\n..35..633.\n......#...\n617*......\n.....+.58.\n..592.....\n......755.\n...$.*....\n.664.598.." | ruby 3.part_numbers.rb
4:
	ruby 4.scratchcards.rb < day-4-input.txt
4_test:
	echo "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\nCard 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\nCard 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\nCard 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\nCard 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\nCard 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11" | ruby 4.scratchcards.rb
