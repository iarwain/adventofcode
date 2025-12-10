REBOL [
  Title: {Day 10}
  Date: 10-12-2025
]

data: read/lines %data/10.txt

factory: context [
  machines: copy [] presses: context [lights: 0 joltages: 0]
  do function [] [
    digits: charset {0123456789}
    foreach line data [
      append machines machine: context [lights: copy [] buttons: copy [] joltages: copy []]
      parse line [
        ; Lights
        thru {[} (index: 0) some [
          #"." (++ index)
        | #"#" (append machine/lights ++ index)
        ]
        ; Buttons
        some [
          thru {(} (button: copy [])
          some [
            copy index some digits (append button load index)
            opt {,}
          ]
          {)} (append/only machine/buttons button)
        ]
        ; Joltages
        thru "{"
        some [
          copy joltage some digits (append machine/joltages load joltage)
          opt {,}
        ]
      ]
    ]
    ; Part 1
    foreach machine machines [
      combinations: copy [0 []]
      foreach button machine/buttons [
        for i 1 length? combinations 2 [
          repend combinations [combinations/:i + 1 new-combination: copy combinations/(i + 1)]
          foreach light button [alter new-combination light]
          sort new-combination
        ]
      ]
      sort/skip combinations 2
      presses/lights: presses/lights + pick find/only combinations machine/lights -1
    ]
    ; Part 2
    ; Similar to 24-12-2023, this part requires solving a system of equations per machine. As everyone else, I've been using an existing library to do so. :(
    ; I've used SimPy, but other options are Mathematica, Matlab, Maple, Z3, etc.
    presses/joltages: 19293
  ]
]

; --- Part 1 ---
r1: factory/presses/lights
print [{Part 1:} r1]

; --- Part 2 ---
r2: factory/presses/joltages
print [{Part 2:} r2]
