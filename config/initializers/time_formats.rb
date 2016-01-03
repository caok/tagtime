Time::DATE_FORMATS.merge!(
  full: '%B %d, %Y at %I:%M %p',
  md: '%m/%d',
  mdy: '%m/%d/%y',
  time: '%I:%M %p'
)

Time::DATE_FORMATS[:default] = "%Y-%m-%d %H:%M:%S"
