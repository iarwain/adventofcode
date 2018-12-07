REBOL [
  Title: {Day 6}
  Date: 06-12-2018
]

data: load replace/all read %data/6.txt {,} {}

; --- Part 1 ---
chronal: context [
  points: land: show: largest: safe: 0
  use [tl br size point blacklist cell coord index process colors acc delta distance colors voronoi] [
    tl: br: as-pair data/1 data/2
    points: map-each [x y] data [
      tl: min tl point: as-pair x y
      br: max br point
      point
    ]
    size: br - tl + 1x1
    land: array/initial size/x * size/y does [context [ids: copy [] distance: 1'000'000 safe: false]]
    forall points [
      points/1: points/1 - tl
      cell: first at land ((points/1/y * size/x) + points/1/x + 1)
      append cell/ids index? points
      cell/distance: 0
    ]
    blacklist: unique collect [
      forall land [
        cell: land/1 acc: 0 coord: as-pair ((index: (index? land) - 1) // size/x) (round/floor index / size/x)
        forall points [
          delta: abs (coord - points/1)
          acc: acc + distance: (delta/x + delta/y)
          case [
            distance < cell/distance [
              cell/distance: distance
              append clear cell/ids index? points
            ]
            distance = cell/distance [
              append cell/ids index? points
            ]
          ]
        ]
        cell/ids: unique cell/ids
        all [acc < 10'000 safe: safe + 1 cell/safe: true]
        all [
          any [(coord/x = 0) (coord/x = (size/x - 1)) (coord/y = 0) (coord/y = (size/y - 1))]
          1 = length? cell/ids
          keep cell/ids/1
        ]
      ]
    ]
    land: head land
    colors: array/initial length? points does [0.0.0.0 + random 255.255.255] voronoi: none
    show: does [
      unless voronoi [
        voronoi: make image! size
        foreach cell land [
          voronoi/1: case [
            empty? cell/ids           [0.0.0.0]
            cell/distance = 0         [255.0.255.0]
            1 < length? cell/ids      [255.255.255.0]
            cell/safe                 [colors/(cell/ids/1) / 1.5]
            find blacklist cell/ids/1 [pick reduce [0.0.0.0 colors/(cell/ids/1)] (0 = mod index? voronoi 3)]
            true                      [colors/(cell/ids/1)]
          ]
          voronoi: next voronoi
        ]
        voronoi: head voronoi
        save/png %voronoi.png to-image layout/tight [image voronoi]
      ]
      view layout [image voronoi [unview]]
    ]
    largest: has [histogram id value] [
      histogram: make hash! []
      foreach cell land [
        all [
          1 = length? cell/ids
          not find blacklist cell/ids/1
          either value: find histogram id: to-string cell/ids/1 [
            value/2: value/2 + 1
          ] [
            repend histogram [id 1]
          ]
        ]
      ]
      first maximum-of/skip next histogram 2
    ]
  ]
]

r1: chronal/largest
print [{part 1:} r1]

; --- Part 2 ---
r2: chronal/safe
print [{part 2:} r2]
