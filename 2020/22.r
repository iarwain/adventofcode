REBOL [
  Title: {Day 22}
  Date: 22-12-2020
]

data: read %data/22.txt

; --- Part 1 ---
combat: context [
  players: copy [] parse data [
    some [
      thru {:} newline (append/only players copy [])
      some [copy card integer! opt newline (append last players load card)]
    ]
  ]
  play: funct [/recursive] [
    resolve: funct [decks] [
      history: copy [] until [
        either recursive [
          either find/only history hands: reduce [copy decks/1 copy decks/2] [
            return 1
          ] [
            append/only history hands
          ]
        ]
        cards: reduce [take decks/1 take decks/2]
        winner: either all [
          recursive
          cards/1 <= length? decks/1
          cards/2 <= length? decks/2
        ] [
          resolve reduce [copy/part decks/1 cards/1 copy/part decks/2 cards/2]
        ] [
          index? maximum-of cards
        ]
        append decks/:winner reduce [cards/:winner cards/(3 - winner)]
        any [empty? decks/1 empty? decks/2]
      ]
      winner
    ]
    resolve decks: copy/deep players
    while [empty? decks/1] [decks: next decks]
    res: 0 repeat i length? decks/1 [res: res + (i * decks/1/((length? decks/1) - i + 1))]
  ]
]
r1: combat/play
print [{Part 1:} r1]

; --- Part 2 ---
r2: combat/play/recursive
print [{Part 2:} r2]
