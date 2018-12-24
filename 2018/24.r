REBOL [
  Title: {Day 24}
  Date: 24-12-2018
]

data: read/lines %data/24.txt

; --- Part 1 ---
reindeer: context [
  fight: boost?: none
  use [init chars faction units hp resist weak damage type] [
    init: collect [
      chars: charset [#"a" - #"z"]
      foreach line data [
        parse line
        [ copy name to {:} (faction: copy name)
        | copy units integer! thru {with} copy hp integer! (resist: copy [] weak: copy [])
          opt [thru {(} some [[{immune to} (attribute: resist) | {weak to} (attribute: weak)] some [copy type some chars opt "," (append attribute copy type)] skip]]
          thru {does} copy damage integer! copy type to {damage} thru {initiative} copy initiative integer!
          (keep/only reduce ['faction faction 'units load units 'hp load hp 'resist resist 'weak weak 'damage load damage 'type copy trim type 'initiative load initiative 'target none])
        ]
      ]
    ]
    use [groups power? damage? target attack battle] [
      power?: func [group] [group/units * group/damage * 100 + group/initiative]
      damage?: func [attacker defender] [
        attacker/units * attacker/damage * case [
          find defender/resist attacker/type  [0]
          find defender/weak attacker/type    [2]
          true                                [1]
        ]
      ]
      target: has [chosen best-damage damage] [
        chosen: copy []
        foreach group sort/compare groups func [a b] [(power? a) > (power? b)] [
          if group/units > 0 [
            group/target: none best-damage: 0
            foreach target groups [
              all [
                target/faction != group/faction
                target/units > 0
                none? find/only chosen target
                best-damage < damage: damage? group target
                (group/target: target best-damage: damage)
              ]
            ]
            all [group/target append/only chosen group/target]
          ]
        ]
      ]
      attack: has [casualties defender kills] [
        casualties: 0
        foreach attacker sort/reverse/compare groups (1 + index? find groups/1 'initiative) [
          all [
            attacker/units > 0
            defender: attacker/target
            0 < kills: min defender/units to-integer (damage: damage? attacker defender) / defender/hp
            (casualties: casualties + kills defender/units: defender/units - kills)
          ]
        ]
        casualties
      ]
      battle: does [
        until [
          target
          any [
            0 = attack
            1 >= length? unique collect [forall groups [all [groups/1/units > 0 keep groups/1/faction]]]
          ]
        ]
      ]
      fight: has [count] [
        groups: copy/deep init
        battle
        count: 0 forall groups [count: count + groups/1/units]
      ]
      boost?: has [boost-range boost apply-boost count] [
        boost-range: copy [0 0] boost: 0
        apply-boost: func [boost] [foreach group groups: copy/deep init [all [group/faction != "Infection" group/damage: group/damage + boost]]]
        until [
          apply-boost boost: either boost-range/1 = first maximum-of boost-range [boost-range/1 + 100] [shift boost-range/1 + boost-range/2 1]
          battle
          count: 0 forall groups [all [groups/1/faction = "Infection" groups/1/units > 0 count: count + 1]]
          boost-range/(pick [2 1] count = 0): boost
          1 = (boost-range/2 - boost-range/1)
        ]
        apply-boost boost-range/2 battle
        count: 0 forall groups [count: count + groups/1/units]
      ]
    ]
  ]
]
r1: reindeer/fight
print [{Part 1:} r1]

; --- Part 2 --
r2: reindeer/boost?
print [{Part 2:} r2]
