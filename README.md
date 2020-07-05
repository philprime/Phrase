# Phrase

Boolean expression evaluation purely written in Swift for macOS & Linux without any dependencies.

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
