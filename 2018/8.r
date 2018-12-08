REBOL [
  Title: {Day 8}
  Date: 08-12-2018
]

data: load %data/8.txt

; --- Part 1 ---
nav: context [
  meta: root: 0
  use [nodes n-queue m-queue process] [
    nodes: copy data n-queue: copy [] m-queue: copy []
    root: do process: has [value children result] [
      insert n-queue take nodes
      insert m-queue take nodes
      result: 0 children: collect [
        repeat i take n-queue [keep process]
      ]
      repeat i take m-queue [
        meta: meta + value: take nodes
        unless empty? children [
          value: any [children/:value 0]
        ]
        result: result + value
      ]
    ]
  ]
]
r1: nav/meta
print [{Part 1:} r1]

; --- Part 2 ---
r2: nav/root
print [{Part 2:} r2]
