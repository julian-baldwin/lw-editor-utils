# LispWorks Editor Utilities

Simple utility commands for the LispWorks editor, similar to paredit or smartparens for Emacs.

## License

### The MIT License

> Copyright (c) 2022 Julian Baldwin.
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
> associated documentation files (the "Software"), to deal in the Software without restriction,
> including without limitation the rights to use, copy, modify, merge, publish, distribute,
> sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or
> substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
> NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
> DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
> OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Requirements

 - LispWorks (tested on LW 8.0 Mac)

## Getting Started

     ;; assuming the system is installed somewhere ASDF can find it
     CL-USER 1 > (asdf:load-system "lw-editor-utils")
     CL-USER 2 > (editor:bind-key "Slurp Forward" "Meta-Ctrl-]" :mode "Lisp")

The function `LW-EDITOR-UTILS:BIND-DEFAULT-KEYS` will set some default bindings, however these are
really based on my own preferences and (for me at least) are similar to what I have set up for
Emacs.

## Commands

Most of these do more-or-less what their paredit or smartparens equivalents are. They're
implemented in terms of the underlying editor commands, so should behave reasonably. They're
generally adequate for my purposes, however I make no promises they won't turn your code into
a sea of mismatched parentheses.

 - `Beginning of Form` -  Move to the first character inside the current form.
 - `End of Form` - Move to the end of the current form (place point on the closing paren).
 - `Backward Down List` - Move to the end of the previous deeper nested form.
 - `Splice Form` - Splice the current form into its parent by removing the parens.
 - `Join Forms` - Join two forms together: `((:one) | (:two)) -> ((:one | :two))`
 - `Slurp Forward` & `Slurp Backward` - Extend the front or end of the current form to
   include the next item.
 - `Barf Forward` & `Barf Backward` - Retract the front or end of the current form to exclude
   items.
