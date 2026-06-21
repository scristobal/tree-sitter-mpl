(
  test:http_requests_total
  | where code >= 500
  | align to 1h using prom::rate
  | group using sum,

  test:http_requests_total
  | align to 1h using prom::rate
  | group using sum,
)
| compute error_rate using /
| map is::lt(0.2)
| align to 1h over 7d using avg

