+++
title = "Markdown"
date = 2025-06-09

taxonomies.tags = [
  "markdown",
  "syntax",
]
taxonomies.categories = [
  "intro"
]
+++

This post demonstrates **CommonMark** features.

## h2 Heading

### h3 Heading

#### h4 Heading

##### h5 Heading

###### h6 Heading

## Features

### Paragraphs

This is a paragraph.

This is another paragraph.

### Text

**Bold Text**: Use `**text**` or `__text__`.

_Italic Text_: Use `*text*` or `_text_`.

~~Strikethrough Text~~: Use `~~text~~`.

`Inline Code`: Use `` `code` ``.

### Lists

#### Ordered Lists

1. First item
2. Second item
3. Third Item
4. Fourth Item
5. Fifth Item
6. Sixth Item
7. Seventh Item
8. Eight Item
9. Ninth Item

#### Unordered Lists

- First item
- Second item

#### Mixed Lists

- First level first unordered item
  1. Second level first ordered item
  2. Second level second ordered item
     - Third level first unordered item
- First level second unordered item

### Links

[Website](https://www.example.com)

[This is such a long link that it will break over to new lines based on the word-break attribute](https:/www.example.com)

### Images

![Rust](/posts/rust.png)

### Blockquotes

> This is a single line blockquote example.

> > This is also a blockquote example.

> This is yet another blockquote example.
>
> This is a multiline blockquote example. It contains multiple paragraphs.

### Code Blocks

```text
This is how code with no syntax highlighting looks like. This sentence keeps on going over the limit.
Here is another sentence.

This is how multiline code looks like.
```

```rust
fn main() {
  let name = "World";
  println!("Hello, {}!", name);
}
```

### Tables

| Feature  | Description       |
| -------- | ----------------- |
| **Bold** | Makes text bold   |
| _Italic_ | Makes text italic |

|  Feature |    Description    |
| -------: | :---------------: |
| **Bold** |  Makes text bold  |
| _Italic_ | Makes text italic |

### Horizontal Rules

---

### Footnotes

Here is a footnote. [^1]

Here is another footnote. [^2] This is the next sentence.

Here is the same footnote referenced again. [^2]

[^1]: Here is a footnote.

[^2]: Footnotes _can be styled_.

    Footnotes can spawn multiple paragraphs.
