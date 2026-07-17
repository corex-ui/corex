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
    files: ["assets/scripts/**/*.{js,mjs,cjs}"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "module",
      globals: {
        process: "readonly",
        console: "readonly",
      },
    },
  },
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
        HTMLTemplateElement: "readonly",
        DocumentFragment: "readonly",
        Element: "readonly",
        NodeList: "readonly",
        Event: "readonly",
        CustomEvent: "readonly",
        CSS: "readonly",
        EventListener: "readonly",
        MouseEvent: "readonly",
        PointerEvent: "readonly",
        File: "readonly",
        HTMLInputElement: "readonly",
        HTMLLIElement: "readonly",
        HTMLSelectElement: "readonly",
        HTMLFormElement: "readonly",
        HTMLButtonElement: "readonly",
        SVGSVGElement: "readonly",
        SVGRectElement: "readonly",
        DOMRect: "readonly",
        requestAnimationFrame: "readonly",
        setTimeout: "readonly",
        clearTimeout: "readonly",
        queueMicrotask: "readonly",
        Animation: "readonly",
        VoidFunction: "readonly",
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