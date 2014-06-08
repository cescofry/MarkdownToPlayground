#MarkdownToPlayground

## Aka mkdtoplg

This is a simple tool that will convert your markdown documentation to a playgorund documentation format for the Swift language.
It is super easy to use you just create your markdown file or take it from a github README file like this one and feed it to tool `mkdtoplg file.md`. The tool will parse all the markdown to a well formatted Playground file, dividing all the HTML from the swift code.

### Example

``` 
let name = "Francesco"
let twitter = "@cescofry"
println("My name is \(name) and you can find me on twitter as \(twitter)")
```

### TODO://

- At the moment the tool will only recognize code sections in between 2 ' \`\`\` ' patterns.
- It is not possible to provide your own css.
- Furthermore even the standard CSS doens't seam to work ;-(


