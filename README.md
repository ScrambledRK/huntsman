# huntsman
data-driven platform agnostic syntax-tree-analyzer

![ExampleResults](https://lh3.googleusercontent.com/-zp7n4AGGLfk/V5Zqgv6ZbjI/AAAAAAAAAMw/yyUetSe3YdE/s1600/overview%25255B32%25255D.png)

---

runtime:
* language specific parsing /tokenizen / syntax-tree-building configurable via json files
* multi-project structure and project dependencies configurable via json file
* syntax-tree-analysis scriptable using haxe-script hscript files
* demo client visualizing the output graph
* custom output format (no support for any graphfile format, but groovy script for to-csv conversion) 
* single threaded and unoptimized filesystem access

development-time:
* convoluted input config parsing
* token must be a regular-expression (comments)
* configuring AST rules (in json) is really frustrating 
