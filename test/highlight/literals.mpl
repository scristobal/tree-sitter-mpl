// Literal forms keep nested string constructs independently highlighted.
set integer = 42;
//            ^^ number
set decimal = -3.5E+2;
//            ^^^^^^^ number
set infinity = +inf;
//             ^^^^ number
set enabled = false;
//            ^^^^^ boolean

param $name: string;
param $fallback: string;

telemetry:events
| filter message == "hello\n \u0041 \$"
//       ^^^^^^^ variable.member
//               ^^ operator
//                  ^ string
//                   ^^^^^ string
//                        ^^ string.escape
//                           ^^^^^^ string.escape
//                                  ^^ string.escape
//                                    ^ string
| filter path == #/^\/api\/(v1|v2)$/
//            ^^ operator
//               ^^^^^^^^^^^^^^^^^^^ string.regexp
| replace route ~ #s/^\/api/(service)/
//        ^^^^^ variable.member
//              ^ operator
//                ^^^^^^^^^^^^^^^^^^^^ string.regexp

// ordinary comment
// ^^^^^^^^ comment
