; Directives and declarations
[
  "set"
  "param"
] @keyword.directive

; Pipeline keywords
[
  "sample"
  "filter"
  "where"
  "ifdef"
  "else"
  "extend"
  "align"
  "to"
  "over"
  "using"
  "group"
  "by"
  "bucket"
  "join"
  "from"
  "map"
  "replace"
  "as"
  "compute"
] @keyword

[
  "and"
  "or"
  "not"
  "is"
] @keyword.operator

[
  "Dataset"
  "Duration"
  "duration"
  "Regex"
  "Option"
  "string"
  "int"
  "float"
  "bool"
] @type.builtin

[
  "rate"
  "increase"
  "histogram"
  "interpolate_delta_histogram"
  "count"
  "avg"
  "sum"
  "min"
  "max"
] @function.builtin

(bucket_by_with_conversion_fn) @function.builtin

(comment) @comment

(plain_identifier) @variable
(escaped_identifier) @variable
(param_ident "$" @punctuation.special) @variable.parameter

(metric_id
  dataset: (_) @module
  name: (_) @function)

(func) @function.call

(string) @string
(interpolation
  ["${" "}"] @punctuation.special)
(escape_sequence) @string.escape

(regex) @string.regexp
(regex_replace) @string.regexp

[
  (int)
  (float)
  (inf)
  (time_relative)
  (time_rfc_3339)
  (time_timestamp)
] @number

(bool) @boolean

[
  "|"
  ":"
  "::"
  ","
  ";"
  ".."
] @punctuation.delimiter

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
  "<"
  ">"
] @punctuation.bracket

[
  "=="
  "!="
  "<="
  ">="
  "<"
  ">"
  "="
  "+"
  "-"
  "*"
  "/"
  "~"
] @operator
