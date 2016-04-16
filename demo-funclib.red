Red [
    Purpose: "Illustrate the use of some funclib.red utilities."
]

; utility to run/display the demos
demo: func [ code /intro text /noresult] [
    if intro [
        prin [ "^/---[  Info  ]------------------------^/" text]
    ]
    print [ "^/---[  code  ]------------------------^/" code]
    either noresult
        [ do code ]
        [
            print "---[ result ]------------------------"
            print mold do code
        ]
]

; Load the library
do %funclib.red

;+-------------------------------------------------------------------+
;|  USE.                                                             |
;+-------------------------------------------------------------------+

demo {x: 1
print x
use [x] [
    x: 4
    print x
]
x}

;+-------------------------------------------------------------------+
;|  APPLY.                                                           |
;+-------------------------------------------------------------------+

demo "apply :add [5 6]"
demo "apply func [x y] [x * y] [5 6]"


;+-------------------------------------------------------------------+
;|  FILTER.                                                          |
;+-------------------------------------------------------------------+

demo {filter [1 2 3 4 5 6] :even?}
demo {filter quote (1 2 3 4 5 6) :odd?}
demo {filter "Un avion qui vole" func [l][find "aeiou" l]}


;+-------------------------------------------------------------------+
;|  MAP.                                                             |
;+-------------------------------------------------------------------+

demo {map :uppercase "aaaaa"}
demo {map func[x][x + 2]  [1 2 3]}
demo {map func[x][x + 2]  quote (1 2 3)}
demo {map :even?  [1 2 3]}


;+-------------------------------------------------------------------+
;|  FOLD.                                                            |
;+-------------------------------------------------------------------+

demo {fold [1 2 3 4 5] :add}
demo {fold quote (1 2 3 4 5) :add}
demo {foldl [1 2 3 4 5] :subtract}
demo {foldr [1 2 3 4 5] :subtract}


;+-------------------------------------------------------------------+
;|  PIPING.                                                          |
;+-------------------------------------------------------------------+

demo {pipe 5 [
   |> multiply 2
   |> probe
   |> subtract 5
   |> probe
   |> either > 10 [ "machin" ][ "bidule" ]
]}

demo {pipe 5 [
   |> multiply 2
   |> probe
   <| subtract 5
]}


;+-------------------------------------------------------------------+
;|  GENERATORS.                                                      |
;+-------------------------------------------------------------------+

demo/intro/noresult {it1: has [n] [ either (n: random 100) > 90 [ none ][ n ]]}
{Defining a function for "generator". Must return some value, or none (when exhausted)}

demo/intro/noresult {it2: context [
    acc: 0
    init: does [acc: 0]
    next: does [
        either (acc: acc + 1) > 10
            [ none ]
            [ acc ]
    ]
]}
{"generator" as an object. As generators, objects are more versatile than function.
Must provite an /init and a /next methods, the later returning some value, or none.
This Generator is a counter, counting from 1 to 10.}


demo/intro/noresult {fibo: context [
    a: 0
    b: 1
    init: does [a: 0 b: 1]
    next: has [c] [
        c: a
        a: b
        b: a + c
        c
    ]
]
}
{Fibonacci sequence "generator". Virtualy infinite, so don't use with forgen
unless you have an escape hatch somewhere...}



;+-------------------------------------------------------------------+
;|  FORGEN is like FOREACH but use an iterator instead of a series.  |
;+-------------------------------------------------------------------+

demo "forgen x :it1 [ print x ]"
demo "forgen x it2 [ print x ]"
demo {forgen x fibo [
    print x
    if x > 30 [break]  ; <-- the escape hatch ;-)
]}
demo "giveme 10 fibo"
demo "giveme/more 10 fibo"
demo "10 more fibo"
