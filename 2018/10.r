REBOL [
  Title: {Day 10}
  Date: 10-12-2018
]

data: read/lines %data/10.txt

; --- Part 1 ---
astrolabe: context [
  time: 0 sky: show: none
  use [size pos vel get-pos approximate star forecast update img txt] [
    size: 250x150
    stars: collect [
      foreach line data [
        parse line [
          thru "<" copy x to "," skip copy y to ">" (pos: as-pair load x load y)
          thru "<" copy x to "," skip copy y to ">" (vel: as-pair load x load y)
          (keep reduce [pos vel])
        ]
      ]
    ]
    get-pos: func [star] [
      add star/1 multiply star/2 time
    ]
    ; About 150 faster than computing the minimum bounding box which would give a more precise time for the word without the need for manual scrubbing
    do approximate: has [to-star distance others] [
      until [
        time: time + 1 star: get-pos stars others: skip stars 2
        forskip others 2 [
          to-star: abs star - get-pos others
          if 100 <= distance: (to-star/x + to-star/y) [break]
        ]
        distance < 100
      ]
    ]
    do forecast: func [time] [
      sky: make image! reduce [size black]
      forskip stars 2 [
        attempt [poke sky subtract get-pos stars (star / 2) white]
      ]
    ] time
    update: func [delta] [
      forecast time: time + delta
      set-face img sky
      set-face txt form time
    ]
    show: has [gui res] [
      gui: layout [
        h3 bold teal "Arrow keys to navigate"
        panel [
          across text bold brick "Time:" txt: text bold leaf form time
          arrow left keycode [down left] [update -1]
          arrow right keycode [up right] [update 1]
        ]
        img: image sky
        vtext crimson "Type the word below then press enter"
        key #"^-" [focus res]
        res: field
        keycode [#"^(esc)" #"^/"] [unview]
      ]
      focus res view gui
      save/png %sky.png sky
      uppercase res/data
    ]
  ]
]
r1: astrolabe/show
print [{Part 1:} r1]

; --- Part 2 ---
r2: astrolabe/time
print [{Part 2:} r2]
