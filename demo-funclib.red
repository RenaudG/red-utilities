Red [
    Purpose: "Illustrate the use of some funclib.red utilities."
]


; "generator" as a function. A generator must return some value, or none (when exhausted)
it1: has [n] [
    either (n: random 100) > 90 [ none ][ n ]
]


; "generator" as an object. As generators, object are more versatile than function.
; Must provite an /init and a /next methods, the later returning some value, or none.
; This Generator is a counter, counting from 1 to 10.
it2: context [
    acc: 0
    init: does [acc: 0]
    next: does [
        either (acc: acc + 1) > 10
            [ none ]
            [ acc ]
    ]
]

; Fibonacci sequence "generator". Virtualy infinite... so don't use with forgen
; unless you have an escape hatch somewhere...
fibo: context [
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


;+-------------------------------------------------------------------+
;|  FORGEN is like FOREACH but use an iterator instead of a series.  |
;+-------------------------------------------------------------------+

print "Test using forgen it1: printing generated values while we get some."
forgen x :it1 [ print x ]

print "Test using forgen it2: printing generated values while we get some."
forgen x it2 [ print x ]

print "Test using forgen fibo: printing generated values while <= 30."
forgen x fibo [
    print x
    if x > 30 [break]
]

print "Test GIVEME: give me 10 fibo"
print mold giveme 10 fibo

print "Test GIVEME/more: give me 10 more fibo"
print mold giveme/more 10 fibo

print "Test GIVEME/more: give me 10 more fibo (operator)"
print mold 10 more fibo


;+-------------------------------------------------------------------+
;|  FORGEN is like FOREACH but use an iterator instead of a series.  |
;+-------------------------------------------------------------------+

p: [
    |> probe
    |> multiply 2
    |> probe
    |> subtract 16
    |> probe
    |> multiply 3
    |> probe
    |> either > 10 [ "machin" ][ "bidule" ]
]
prin "Testing a first pipe: "
print replace/all mold p "|>" "^/|>^-"
print ["pipe 10 p: " pipe 10 p "^/------^/"]


print "Creating a function with PIPER: in N first fibo numbers, sum the ven ones"
pp: piper [
    |> probe
    |> giveme fibo
    |> probe
    |> filter func [x] [(x % 2) = 0]
    |> probe
    |> fold :add
]
print [ "pp 10: " pp 10 "^/------^/"]
print [ "pp 30: " pp 30 "^/------^/"]


;+-------------------------------------------------------------------+
;|  APPLY.                                                           |
;+-------------------------------------------------------------------+

print ["apply :add [5 6] => " apply :add [5 6]]
print ["apply func [x y] [ x * y] [5 6] => " apply func [x y] [x * y] [5 6]]
