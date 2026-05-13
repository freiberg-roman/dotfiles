--- @class _99.ops.Opts
--- The options that are used throughout all the interations with 99.  This
--- includes search, visual, and others
---
--- @docs included
--- @field additional_prompt? string
--- by providing `additional_prompt` you will not be required to provide a prompt.
--- this allows you to define actions based on remaps
--- @field additional_rules? _99.Agents.Rule[]
--- can be used to provide extra args.  If you have a skill called "cloudflare" you could
--- provide the rule for cloudflare and its context will be injected into your request

return {
  over_range = require("99.ops.over-range"),
}
