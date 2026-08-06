// Literal forms keep nested string constructs independently highlighted.
set integer = 42;
//            ^^ @constant.numeric
set decimal = -3.5E+2;
//            ^^^^^^^ @constant.numeric
set infinity = +inf;
//             ^^^^ @constant.numeric
set enabled = false;
//            ^^^^^ @constant.builtin.boolean

param $name: string;
param $fallback: string;

telemetry:events
| filter message == "hello\n \u0041 \$"
//       ^^^^^^^ @variable.other.member
//               ^^ @operator
//                  ^ @string
//                   ^^^^^ @string
//                        ^^ @constant.character.escape
//                           ^^^^^^ @constant.character.escape
//                                  ^^ @constant.character.escape
//                                    ^ @string
| filter path == #/^\/api\/(v1|v2)$/
//            ^^ @operator
//               ^^^^^^^^^^^^^^^^^^^ @string.regexp
| replace route ~ #s/^\/api/(service)/
//        ^^^^^ @variable.other.member
//              ^ @operator
//                ^^^^^^^^^^^^^^^^^^^^ @string.regexp

// ordinary comment
// ^^^^^^^^ @comment
