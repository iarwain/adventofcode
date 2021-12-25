REBOL [
  Title: {Day 25}
  Date: 25-12-2021
]

data: read/lines %data/25.txt

; --- Part 1 ---
seafloor: context [
  settle: funct [] [
    cucumbers: copy/deep data size: as-pair length? cucumbers/1 length? cucumbers step: 0
    until [
      step: step + 1 moved: false
      foreach [type dir] [
        #">"  0x-1
        #"v"  -1x0
      ] [
        new: array/initial reduce [size/y size/x] #"."
        repeat y size/y [
          repeat x size/x [
            case [
              all [
                cucumbers/:y/:x = type
                fwd: (as-pair x y) + dir // size + 1x1
                cucumbers/(fwd/y)/(fwd/x) = #"."
              ] [
                ;print [{type} type {:} as-pair x y {->} fwd]
                new/(fwd/y)/(fwd/x): type
                moved: true
              ]
              cucumbers/:y/:x != #"." [
                new/:y/:x: cucumbers/:y/:x
              ]
            ]
          ]
        ]
        cucumbers: new
      ]
      not moved
    ]
    step
  ]
]

r1: seafloor/settle
print [{Part 1:} r1]

; --- Part 2 ---
r2: {There's no part 2! :-)}
print [{Part 2:} r2]
