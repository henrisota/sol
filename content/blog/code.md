+++
title = "Code"
date = 2025-07-06

taxonomies.tags = [
  "code",
  "syntax",
]
taxonomies.categories = [
  "intro"
]
+++

## Syntax Highlighting

```rust
fn main() {
  let name = "World";
  println!("Hello, {}!", name);
}
```

## Line Numbering

```rust,linenos
use highlighter::highlight;
let code = "...";
highlight(code);
```

## Setting first line number

```rust,linenos,linenostart=8
use highlighter::highlight;
let code = "...";
highlight(code);
```

## Highlighting lines

```rust,hl_lines=1 3-5 9
use highlighter::highlight;
let code = "...";
highlight(code);
```

## Hiding lines

```rust,hide_lines=1-2
use highlighter::highlight;
let code = "...";
highlight(code);
```

## Naming code blocks

```rust,name=mod.rs
use highlighter::highlight;
let code = "...";
highlight(code);
```

## Combined

```rust,linenos,linenostart=5,name=mod.rs,hl_lines=1 3,hide_lines=1,name=combined.rs
use highlighter::highlight;
let code = "...";
highlight(code);
return
```
