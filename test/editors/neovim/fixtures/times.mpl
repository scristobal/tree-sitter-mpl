// Relative, RFC 3339, timestamp, and modified times are numeric literals.
(
  telemetry:started[1h..2025-01-02T03:04:05Z],
//                 ^ punctuation.bracket
//                  ^^ number
//                    ^^ punctuation.delimiter
//                      ^^^^^^^^^^^^^^^^^^^^ number
//                                          ^ punctuation.bracket
//                                           ^ punctuation.delimiter
  telemetry:finished[1700000000..+5m]
//                  ^ punctuation.bracket
//                   ^^^^^^^^^^ number
//                             ^^ punctuation.delimiter
//                               ^ operator
//                                ^^ number
//                                  ^ punctuation.bracket
)
// <- punctuation.bracket
| compute elapsed using -
// <- punctuation.delimiter
//^^^^^^^ keyword
//        ^^^^^^^ variable
//                ^^^^^ keyword
//                      ^ operator
