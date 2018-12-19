REBOL [
  Title: {Day 17}
  Date: 17-12-2018
]

data: read/lines %data/17.txt

; --- Part 1 ---
scan: context [
  spring: 500x0 ground: process: show: still-waters: running-waters: none
  use [clay waters still-water running-water spring-water soft sand walls x y x1 x2 y1 y2 xmin xmax ymin ymax init] [
    clay: sienna waters: reduce [still-water: teal running-water: cyan spring-water: aqua] soft: reduce [sand: wheat running-water spring-water]
    walls: collect [
      foreach line data [
        parse line [
          [ "x=" copy x integer! {, y=} copy y1 integer! {..} copy y2 integer! (x: load x for y y1: load y1 y2: load y2 1 [keep reduce [x y]])
          | "y=" copy y integer! {, x=} copy x1 integer! {..} copy x2 integer! (y: load y for x x1: load x1 x2: load x2 1 [keep reduce [x y]])
          ]
        ]
      ]
    ]
    xmin: (first minimum-of/skip walls 2) - 1 xmax: (first maximum-of/skip walls 2) + 1
    ymin: first minimum-of/skip next walls 2 ymax: first maximum-of/skip next walls 2
    ground: make image! reduce [as-pair xmax - xmin + 1 ymax - ymin + 1 sand]
    foreach [x y] walls [ground/(as-pair x - xmin y - ymin): clay]
    init: copy ground
    use [modified] [
      fill: funct [pos] [
        spread: false
        while [find soft ground/(pos + 0x1)] [
          ground/(pos: pos + 0x1): running-water spread: true
          all [pos/y = (ymax - ymin) return]
        ]
        left: right: pos
        while [ground/(left - 1x0) != clay] [
          ground/(left: left - 1x0): running-water
          if find soft ground/(left + 0x1) [
            fill left spread: false break
          ]
        ]
        while [ground/(right + 1x0) != clay] [
          ground/(right: right + 1x0): running-water
          if find soft ground/(right + 0x1) [
            fill right spread: false break
          ]
        ]
        if spread [change/dup at ground left still-water right - left + 1x1 set 'modified true]
      ]
      process: has [source] [
        change at ground: copy init source: as-pair spring/x - xmin max 0 spring/y - ymin spring-water
        until [
          modified: false
          fill source
          not modified
        ]
        save/png %ground.png ground
      ]
      still-waters: has [count] [count: 0 forall ground [all [find waters ground/1 count: count + 1]] count]
      running-waters: has [count] [count: 0 forall ground [all [ground/1 = still-water count: count + 1]] count]
      show: does [view layout [image ground key #"^(esc)" [unview]]]
    ]
  ]
]
scan/process
r1: scan/still-waters
print [{Part 1:} r1]

; --- Part 2 ---
r2: scan/running-waters
print [{Part 2:} r2]
