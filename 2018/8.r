REBOL [
  Title: {Day 8}
  Date: 08-12-2018
]

data: load %data/8.txt

; --- Part 1 ---
nav: context [
  meta: root: 0
  use [nodes n-stack m-stack process] [
    nodes: copy data n-stack: copy [] m-stack: copy []
    root: do process: has [value children result] [
      insert n-stack take nodes
      insert m-stack take nodes
      result: 0 children: collect [
        loop take n-stack [keep process]
      ]
      loop take m-stack [
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
