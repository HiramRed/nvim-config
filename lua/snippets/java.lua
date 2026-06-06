local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local fmt = require("luasnip.extras.fmt").fmt

luasnip.add_snippets("java", {
  -- psf: private static final
  s("psf", fmt("private static final {} {} = {};", {
    i(1, "Type"),
    i(2, "NAME"),
    i(3, "value"),
  })),

  -- .var: var 类型推断
  s(".var", fmt("var {} = {};", {
    i(1, "name"),
    i(2, "value"),
  })),

  -- psvm: main 方法
  s("psvm", {
    t("public static void main(String[] args) {"),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- fori: for 循环
  s("fori", {
    fmt("for (int {} = 0; {} < {}; {}++) {{", {
      i(1, "i"),
      i(1, "i"),
      i(2, "length"),
      i(1, "i"),
    }),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- foreach: 增强 for 循环
  s("foreach", {
    fmt("for ({} {} : {}) {{", {
      i(1, "Type"),
      i(2, "item"),
      i(3, "collection"),
    }),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- if: if 语句
  s("if", {
    fmt("if ({}) {{", { i(1, "condition") }),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- ife: if-else
  s("ife", {
    fmt("if ({}) {{", { i(1, "condition") }),
    t({ "", "\t" }),
    i(2),
    t({ "", "} else {" }),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- class: 类定义
  s("class", {
    fmt("public class {} {{", { i(1, "ClassName") }),
    t({ "", "\t" }),
    i(0),
    t({ "", "}" }),
  }),

  -- soutv: 带变量的 System.out.println
  s("soutv", fmt('System.out.println("{} = " + {});', {
    i(1, "var"),
    i(1, "var"),
  })),
})
