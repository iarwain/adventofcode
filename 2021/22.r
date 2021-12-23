REBOL [
  Title: {Day 22}
  Date: 22-12-2021
]

; !! This one requires REBOL 3 due to the 32bit signed integer limitation of REBOL 2 !!

data: read/lines %data/22.txt

reactor: context [
  reboot: steps: none
  use [step xmin xmax ymin ymax zmin zmax] [
    steps: map-each line data [
      parse line [
        copy step [{on} | {off}]
        thru {x=} copy xmin to {..} {..} copy xmax to {,} {,}
        thru {y=} copy ymin to {..} {..} copy ymax to {,} {,}
        thru {z=} copy zmin to {..} {..} copy zmax to end
      ]
      context [state: step = {on} x: as-pair load xmin load xmax y: as-pair load ymin load ymax z: as-pair load zmin load zmax]
    ]
    reboot: funct [/init] [
      intersect?: funct[a b] [
        all [
          b/x/2 >= a/x/1 a/x/2 >= b/x/1
          b/y/2 >= a/y/1 a/y/2 >= b/y/1
          b/z/2 >= a/z/1 a/z/2 >= b/z/1
        ]
      ]
      cuboids: reduce [
        context [
          state: false x: y: z: 0x0
          foreach step steps [foreach axis [x y z] [set axis as-pair (min first get axis step/:axis/1) (max second get axis step/:axis/2)]]
        ]
      ]
      foreach step steps [
        if init [
          step: make step []
          foreach axis [x y z] [step/:axis/1: max step/:axis/1 -50 step/:axis/2: min step/:axis/2 50]
          if any [
            step/x/2 < step/x/1
            step/y/2 < step/y/1
            step/z/2 < step/z/1
          ] [continue]
        ]
        cuboids: collect [
          foreach cuboid cuboids [
            either all [cuboid/state != step/state intersect? step cuboid] [
              foreach axis [x y z] [
                case/all [
                  cuboid/:axis/1 < step/:axis/1 [keep also new: make cuboid [] new/:axis/2: (cuboid/:axis/1: step/:axis/1) - 1]
                  cuboid/:axis/2 > step/:axis/2 [keep also new: make cuboid [] new/:axis/1: (cuboid/:axis/2: step/:axis/2) + 1]
                ]
              ]
              keep make cuboid [state: step/state]
            ] [
              keep make cuboid []
            ]
          ]
        ]
      ]
      result: 0 foreach cuboid cuboids [
        all [
          cuboid/state
          volume: 1 foreach axis [x y z] [volume: volume * (cuboid/:axis/2 - cuboid/:axis/1 + 1)]
          result: to-integer result + volume
        ]
      ]
      result
    ]
  ]
]

; --- Part 1 ---
r1: reactor/reboot/init
print [{Part 1:} r1]

; --- Part 2 ---
r2: reactor/reboot
print [{Part 2:} r2]
