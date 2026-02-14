import js from "@eslint/js";
import tsPlugin from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser";
import prettierConfig from "eslint-config-prettier";

export default [
  {
    ignores: ["priv/**", "node_modules/**", "*.cjs.js", "*.min.js"],
  },
  js.configs.recommended,
  {
    files: ["assets/**/*.ts", "assets/**/*.js"],
    languageOptions: {
      parser: tsParser,
      parserOptions: {
        ecmaVersion: 2020,
        sourceType: "module",
      },
      globals: {
        window: "readonly",
        document: "readonly",
        Document: "readonly",
        console: "readonly",
        navigator: "readonly",
        HTMLElement: "readonly",
        Element: "readonly",
        NodeList: "readonly",
        Event: "readonly",
        CustomEvent: "readonly",
        EventListener: "readonly",
        HTMLInputElement: "readonly",
        HTMLSelectElement: "readonly",
        HTMLFormElement: "readonly",
        SVGSVGElement: "readonly",
        SVGRectElement: "readonly",
        requestAnimationFrame: "readonly",
        setTimeout: "readonly",
      },
    },
    plugins: {
      "@typescript-eslint": tsPlugin,
    },
    rules: {
      ...tsPlugin.configs.recommended.rules,
      "@typescript-eslint/no-unused-vars": [
        "error",
        { argsIgnorePattern: "^_" },
      ],
    },
  },
  prettierConfig,
];