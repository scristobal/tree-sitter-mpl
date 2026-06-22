/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

const PREC = {
  or: 1,
  and: 2,
  not: 3,
};

module.exports = grammar({
  name: "mpl",

  extras: ($) => [
    /[\s\r\n\t]/,
    $.comment,
  ],

  word: ($) => $.plain_identifier,

  rules: {
    source_file: ($) => seq(
      repeat($.directive),
      repeat($.param),
      $.query,
    ),

    comment: () => token(seq("//", /.*/)),

    query: ($) => choice(
      $.simple_query,
      $.compute_query,
    ),

    simple_query: ($) => seq(
      $.source,
      optional($.sample_rule),
      repeat(choice($.filter_rule, $.ifdef_rule)),
      repeat($.pipe_rule),
      repeat($.extend_rule),
    ),

    compute_query: ($) => seq(
      "(",
      field("left", $.query),
      ",",
      field("right", $.query),
      optional(","),
      ")",
      $.compute_rule,
      repeat($.pipe_rule),
    ),

    source: ($) => seq(
      field("metric", $.metric_id),
      optional(field("time_range", $.time_range)),
      optional($.as_clause),
    ),

    metric_id: ($) => seq(
      field("dataset", choice($.identifier, $.param_ident)),
      ":",
      field("name", $.metric_name),
    ),

    metric_name: ($) => $.identifier,

    directive: ($) => seq(
      "set",
      field("name", $.identifier),
      optional(seq("=", field("value", choice($.const, $.identifier)))),
      ";",
    ),

    param: ($) => seq(
      "param",
      field("name", $.param_ident),
      ":",
      field("type", $.param_type),
      ";",
    ),

    param_type: ($) => choice(
      $.param_native_type,
      $.tag_type,
      $.optional_type,
    ),

    param_native_type: () => choice("Dataset", "Duration", "duration", "Regex"),
    tag_type: () => choice("string", "int", "float", "bool"),

    optional_type: ($) => seq(
      "Option",
      "<",
      choice($.tag_type, $.param_native_type),
      ">",
    ),

    sample_rule: ($) => seq("|", $.sample_expr),
    sample_expr: ($) => seq("sample", field("ratio", $.number)),

    filter_rule: ($) => seq("|", $.filter_expr),
    filter_expr: ($) => seq(
      field("keyword", choice("filter", "where")),
      field("condition", $._filter_condition),
    ),

    _filter_condition: ($) => choice(
      $.filter_atom,
      $.parenthesized_filter,
      $.not_filter,
      $.and_filter,
      $.or_filter,
    ),

    or_filter: ($) => prec.left(PREC.or, seq(
      field("left", $._filter_condition),
      "or",
      field("right", $._filter_condition),
    )),

    and_filter: ($) => prec.left(PREC.and, seq(
      field("left", $._filter_condition),
      "and",
      field("right", $._filter_condition),
    )),

    not_filter: ($) => prec(PREC.not, seq(
      "not",
      field("condition", $._filter_condition),
    )),

    parenthesized_filter: ($) => seq(
      "(",
      field("condition", $._filter_condition),
      ")",
    ),

    filter_atom: ($) => seq(
      field("tag", $.identifier),
      choice($.value_filter, $.regex_filter, $.is_filter),
    ),

    value_filter: ($) => seq(field("operator", $.cmp), field("value", $.expr)),
    regex_filter: ($) => seq(field("operator", $.cmp_re), field("value", $.regex)),
    is_filter: ($) => seq("is", field("type", $.tag_type)),

    ifdef_rule: ($) => seq(
      "|",
      "ifdef",
      "(",
      field("parameter", $.param_ident),
      ")",
      "{",
      field("then", $.filter_expr),
      "}",
      optional(seq(
        "else",
        "{",
        field("else", $.filter_expr),
        "}",
      )),
    ),

    pipe_rule: ($) => seq(
      "|",
      choice(
        $.align,
        $.map,
        $.group_by,
        $.replace,
        $.bucket_by,
        $.join,
        $.as_clause,
      ),
    ),

    extend_rule: ($) => prec.right(seq(
      "|",
      "extend",
      $.extend_expr,
      repeat(seq(",", $.extend_expr)),
    )),

    extend_expr: ($) => seq(
      field("name", $.identifier),
      "=",
      field("value", $.expr),
    ),

    align: ($) => seq(
      "align",
      optional(seq("to", field("window", $.time_relative_parameterized))),
      optional(seq("over", field("period", $.time_relative_parameterized))),
      "using",
      field("function", $.func),
    ),

    group_by: ($) => seq(
      "group",
      optional(seq("by", field("tags", $.tags))),
      "using",
      field("function", $.func),
    ),

    bucket_by: ($) => seq(
      "bucket",
      optional(seq("by", field("tags", $.tags))),
      optional(seq("to", field("window", $.time_relative_parameterized))),
      "using",
      field("function", $.bucket_fn_call),
    ),

    join: ($) => seq(
      "join",
      field("tags", $.tags),
      "from",
      field("source", $.metric_id),
      "by",
      field("by", $.tags),
    ),

    map: ($) => seq(
      "map",
      choice($.map_eval, $.map_fn),
    ),

    map_eval: ($) => seq(
      field("operator", $.map_calc_op),
      field("value", $.number),
    ),

    map_calc_op: () => choice("+", "-", "*", "/"),

    map_fn: ($) => seq(
      field("function", $.func),
      optional(seq("(", field("argument", $.number), ")")),
    ),

    as_clause: ($) => seq("as", field("alias", $.metric_name)),

    replace: ($) => seq(
      "replace",
      choice(
        $.replace_rename_tag,
        $.replace_tag,
        $.replace_rename,
      ),
    ),

    replace_tag: ($) => seq(field("tag", $.identifier), "~", field("replacement", $.regex_replace)),
    replace_rename: ($) => seq(field("name", $.identifier), "=", field("tag", $.identifier)),
    replace_rename_tag: ($) => seq(field("name", $.identifier), "=", field("tag", $.identifier), "~", field("replacement", $.regex_replace)),

    compute_rule: ($) => seq(
      "|",
      "compute",
      field("name", $.metric_name),
      "using",
      field("function", $.compute_fn),
    ),

    compute_fn: ($) => choice($.func, $.compute_op),
    compute_op: () => choice("/", "*", "+", "-"),

    tags: ($) => prec.right(seq($.identifier, repeat(seq(",", $.identifier)))),

    bucket_fn_call: ($) => choice(
      $.bucket_fn_call_with_conversion,
      $.bucket_fn_call_simple,
    ),

    bucket_fn_call_with_conversion: ($) => seq(
      field("name", $.bucket_by_with_conversion_fn),
      "(",
      field("conversion", $.bucket_conversion),
      ",",
      field("specs", $.bucket_specs),
      ")",
    ),

    bucket_fn_call_simple: ($) => seq(
      field("name", $.bucket_by_fn),
      "(",
      optional(field("specs", $.bucket_specs)),
      ")",
    ),

    bucket_conversion: () => choice("rate", "increase"),
    bucket_by_fn: () => choice("histogram", "interpolate_delta_histogram"),
    bucket_by_with_conversion_fn: () => "interpolate_cumulative_histogram",

    bucket_specs: ($) => seq($.bucket_spec, repeat(seq(",", $.bucket_spec))),
    bucket_spec: ($) => choice("count", "avg", "sum", "min", "max", $.number),

    func: ($) => seq(
      repeat(seq($.module, "::")),
      $.identifier,
    ),

    module: ($) => $.identifier,

    expr: ($) => choice(
      $.const,
      $.param_ident,
      $.identifier,
    ),

    const: ($) => choice(
      $.string,
      $.float,
      $.int,
      $.bool,
      $.inf,
    ),

    time_range: ($) => seq(
      "[",
      field("start", $.time),
      "..",
      optional(field("end", $.time)),
      "]",
    ),

    time: ($) => choice(
      $.time_relative,
      $.time_rfc_3339,
      $.time_timestamp,
      $.time_modifier,
    ),

    time_modifier: ($) => seq(
      field("direction", choice("+", "-")),
      field("duration", $.time_relative),
    ),

    time_relative_parameterized: ($) => choice($.time_relative, $.param_ident),
    time_relative: () => token(seq(/[0-9]+/, choice("ms", "s", "m", "h", "d", "w", "M", "y"))),
    time_rfc_3339: () => token(/[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z?/),
    time_timestamp: () => token(/[0-9]+/),

    param_ident: ($) => seq("$", $.identifier),

    identifier: ($) => choice(
      $.plain_identifier,
      $.escaped_identifier,
    ),

    plain_identifier: () => /[A-Za-z_][A-Za-z0-9_]*/,

    escaped_identifier: ($) => seq(
      "`",
      repeat(choice($.escaped_identifier_content, $.escape_sequence)),
      "`",
    ),

    escaped_identifier_content: () => token.immediate(prec(1, /[^`\\]+/)),

    string: ($) => seq(
      "\"",
      repeat(choice($.string_content, $.escape_sequence, $.interpolation)),
      "\"",
    ),

    interpolation: ($) => seq(
      "${",
      $.expr,
      "}",
    ),

    string_content: () => token.immediate(prec(1, /[^"\\$]+|\$/)),
    escape_sequence: () => token.immediate(/\\(["\\\/bfnrt$`]|u[0-9a-fA-F]{4})/),

    regex: () => token(/#\/([^\/\\]|\\.)*\//),
    regex_replace: () => token(/#s\/([^\/\\]|\\.)*\/([^\/\\]|\\.)*\//),

    cmp: () => choice("==", "!=", "<=", "<", ">=", ">"),
    cmp_re: () => choice("==", "!="),

    number: ($) => choice($.inf, $.float, $.int),
    inf: () => token(choice("inf", "+inf", "-inf")),
    float: () => token(seq(/[+-]?[0-9]+/, ".", /[0-9]*/, optional(seq(choice("e", "E"), /[+-]?[0-9]+/)))),
    int: () => token(/[+-]?[0-9]+/),
    bool: () => choice("true", "false"),
  },
});
