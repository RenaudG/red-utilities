Red [
    Title:  "Useful functions (WIP)"
    Author: "Renaud GOMBERT"
    File:    %funclib.red
    Tabs:    4
    Rights:  "Copyright (C) 2016+ Renaud GOMBERT, All rights reserved."
    License: {
        Distributed under the Boost Software License, Version 1.0.
        See https://github.com/red/red/blob/master/BSL-License.txt
    }
]


; ------------------------[ USEFUL THINGS ]------------------------

use: func [
    "Evaluate code while preventing vars to leak in global space"
    vars [bloc!]    "List of variables to keep local"
    code [bloc!]    "Code to execute"
] [
    do has vars code
]


apply: func [
    "Apply a function to a block: apply :add [1 2] <=> add 1 2"
    f   [function! action!] "Function to apply"
    blk [block!]            "Argument list"
][
    do head insert blk :f
]


filter: func [
    "Return only the values for wich f(v) is true"
    blk [any-block!] "List of value to filter"
    f   [function!]  "Predicate for values to satisfy"
    /local acc
][
    acc: copy []
    foreach v blk [ if f v [append/only acc v] ]
    acc
]


map: func [
    "Apply a function to all values in a block"
    blk [any-block!] "List of values"
    f   [function!]  "Function to apply on values"
    /local acc v
][
    acc: copy []
    foreach v blk [ append/only acc f v ]
]


fold: foldl: func [
    "Fold a bloc from the left with a function"
    blk [any-block!]        "List of values to fold"
    f   [function! action!] "Folding function"
    /seed s                 "Start with this value instead of first item"
    /local v x
][
    either seed [ v: s ]
                [ v: blk/1 blk: next blk]
    foreach x blk [ v: f v x ]
    v
]


foldr: func [
    "Fold a bloc from the right with a function"
    blk [any-block!]        "List of values to fold"
    f   [function! action!] "Folding function"
    /seed s                 "Start with this value instead of last item"
    /local v x
][
    blk: reverse copy blk
    either seed [ v: s ]
                [ v: blk/1 blk: next blk]
    foreach x blk [ v: f x v ]
    v
]


; ------------------------[ PIPING TOOLS ]------------------------


pipe: func [
    "Successively pipe a value as 1st (|>) or last (<|) argument of function calls"
    seed            "Starting value"
    block [block!]  "Sequence of pipeable instructions"
    /local fun?
    /only           "Return a code block instead of doing it"
][
    fun?: 1
    seed: append/only make paren! 1 seed
    foreach item block [
        switch/default item [
            '|> [ fun?: 1  seed: append/only make paren! 3 head seed]
            '<| [ fun?: 2  seed: append/only make paren! 3 head seed]
        ][  switch fun? [
                0 [ append/only seed item ]
                1 [ insert/only seed item fun?: 0 ]
                2 [ insert/only seed item  seed: next seed ]
            ]
        ]
    ]
    either only [ append make block! 1 head seed ] [ do head seed ]
]


; Make an operator from the pipe word
|>: make op! :pipe


piper: func [
    "Build a function from a pipe block"
    body [block!] "Sequence of pipeable instructions"
][
    func [x] pipe/only 'x body
]


; ------------------------[ GENERATOR TOOLS ]------------------------

; An iterator can be a simple FUNCTION or an object with
; INIT and NEXT methods.

forgen: func [
    "Runs a body of code while a generator has values to provide"
    'var    "Variable name used in body"
    f       "Iterator as an object or a function"
    body    "Code to execute"
] [
    bind body 'var
    if (type? f) = object! [f/init f: :f/next]
    while [set var f] [ do body ]
]


giveme: func [
    "Collect n values from an iterator"
    n   "Number of values to collect"
    f   "Iterator as an object or a function"
    /local acc
    /more "Skips the iterator initialisation"
] [
    if (type? f) = object! [
        unless more [ f/init ]
        f: :f/next
    ]
    acc: copy []
    loop n [ append acc f ]
]


more: make op! func [
    "Collect n next values from an iterator"
    n   "Number of values to collect"
    f   "Iterator as an object or a function"
] [
    giveme/more n f
]


nth: func [
    "Return the Nth value from an iterator"
    f "Iterator"
    n [integer!] ""
    /local v
][
    if (type? f) = object! [f/init f: :f/next]
    if n < 1 [return none]
    loop n [ unless v: f [ return none ] ]
    v
]
