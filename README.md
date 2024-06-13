# README

Simple web-app for tracking coffee drinking with friends.
The original motivation was to help me make better coffee
during the pandemic, as well as trying Hotwire.

## Features

- Detailed coffee drinking log designed for tracking recipe details daily.
- Database of coffees and brands.
- Use of Hotwire for interactive features. (This was a major motivation for building it.)
- Heavy use of Active Storage for user-uploaded imagery.
- Use of import maps.
- Custom authentication flows and signup codes.

## Why it wasn't as useful as I hoped

It turned out to be far easier to narrow down a recipe through simple memory.
The most important variable - grind size - is almost impossible to log accurately
with most grinders! So I would just remember "I want to try a bit smaller today"
or "maybe a bit larger" and whether it subsequently tasted better than yesterday.

## TODO

- [x] Error on reset password form not handled
- [x] Password reset form has different width
- [ ] Make it easier to add a log entry for a drink that isn't in the database
- [ ] Add tasting sheets
- [ ] Add recipes
- [ ] Less Bootstrap-y nav-bar
- [ ] Make some use of new logos from "bulma" branch

## Recommended .vscode/settings.json

```json
{
  "editor.formatOnSave": false,
  "[ruby]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "Shopify.ruby-lsp"
  },
  "rubyLsp.formatter": "rubocop",
  "[javascript]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "sorbet.enabled": false,
  "files.associations": {
    "*.css": "css"
  }
}
```
