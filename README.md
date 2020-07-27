# Phrase

[![CI](https://github.com/philprime/Phrase/workflows/Build,%20Lint%20&%20Test/badge.svg)](https://github.com/philprime/Phrase/actions)
[![Documentation](https://raw.githubusercontent.com/philprime/Phrase/gh-pages/badge.svg)](https://philprime.github.io/Phrase/)
[![codecov](https://codecov.io/gh/philprime/Phrase/branch/main/graph/badge.svg)](https://codecov.io/gh/philprime/Phrase)



Boolean expression evaluation purely written in Swift for 
macOS & Linux without any dependencies.

- [Documentation](https://philprime.github.io/Phrase/)

## Usage

```swift
let expression = try Phrase("list != nil && list.count > 3")
expression.context = [
   "list": [1,2,3,4,5]
]
if try expression.evaluate() {
   ...
} else {
   ...
}
```

### Operators

#### Prefix-Operators

Operators which require a succeeding node

- `!`

#### Infix-Operators

Operators which require a preceding and a succeeding node

##### Logical:

- `&&`
- `||`

##### Equaltiy:

- `==`
- `!=`

##### Comparing:

- `>`
- `>=`
- `<`
- `<=`

#### Postfix-Operators

Operators which require a preceeding node

- `count`

> returns the element count of the preceeding array node