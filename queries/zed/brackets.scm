("(" @open ")" @close)
("[" @open "]" @close)
("{" @open "}" @close)

(optional_type
  "<" @open
  ">" @close)

(interpolation
  "${" @open
  "}" @close)

(string
  . "\"" @open
  "\"" @close .)

(escaped_identifier
  . "`" @open
  "`" @close .)
