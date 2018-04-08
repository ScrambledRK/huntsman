# huntsman
data-driven platform agnostic syntax-tree-analyzer

---

runtime:
* language specific parsing /tokenizen / syntax-tree-building configurable via json files
* multi-project structure and project dependencies configurable via json file
* syntax-tree-analysis scriptable using haxe-script hscript files
* demo client visualizing the output graph
* custom output format (no support for any graphfile format) 
* single threaded and unoptimized filesystem access

development-time:
* convoluted input config parsing
* token must be a regular-expression (comments)
* configuring AST rules (in json) is really frustrating 
