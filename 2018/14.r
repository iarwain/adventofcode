REBOL [
  Title: {Day 14}
  Date: 14-12-2018
]

data: read %data/14.txt

; --- Part 1 ---
cookbook: context [
  recipes: forecast: search: none
  use [init bake end elf1 elf2] [
    init: does [end: insert elf1: recipes: copy {} {37} elf2: next elf1]
    bake: has [recipe1 recipe2 count] [
      end: insert end form (recipe1: load copy/part elf1 1) + recipe2: load copy/part elf2 1
      elf1: at recipes 1 + ((index? elf1) + recipe1 // count: length? recipes)
      elf2: at recipes 1 + ((index? elf2) + recipe2 // count)
    ]
    forecast: func [count [integer!]] [
      init loop count [bake]
      copy/part at recipes count + 1 10
    ]
    search: funct [pattern [string!]] [
      init until [bake result: find skip end -7 pattern]
      (index? result) - 1
    ]
  ]
]
r1: cookbook/forecast load data
print [{Part 1:} r1]

; --- Part 2 ---
r2: cookbook/search data
print [{Part 2:} r2]
