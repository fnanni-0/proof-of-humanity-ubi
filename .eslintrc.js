module.exports = {
  // Don't merge into parent configs.
  root: true,

  // Enable globals.
  env: {
    es2021: true,
    node: true,
    mocha: true,
  },
  globals: {
    bre: "readonly",
    ethers: "readonly",
    usePlugin: "readonly",
    waffle: "readonly",
  },

  extends: [
    // Core
    "eslint:recommended",

    // Import Plugin
    "plugin:import/errors",

    // Unicorn Plugin
    "plugin:unicorn/recommended",

    // Prettier Plugin
    "plugin:prettier/recommended",
  ],
  plugins: ["regex"],

  rules: {
    // Core
    "arrow-body-style": "error", // Don't use unnecessary curly braces for arrow functions.
    "capitalized-comments": "error",
    "new-cap": "error", // Require constructor names to begin with a capital letter.
    "new-parens": "error",
    "no-array-constructor": "error",
    "no-console": "error",
    "no-duplicate-imports": ["error", {includeExports: true}],
    "no-else-return": ["error", {allowElseIf: false}],
    "no-extra-bind": "error",
    "no-iterator": "error",
    "no-lonely-if": "error", // In else blocks.
    "no-new-wrappers": "error",
    "no-proto": "error",
    "no-return-await": "error",
    "no-shadow": "error",
    "no-unneeded-ternary": ["error", {defaultAssignment: false}],
    "no-unused-expressions": "error",
    "no-use-before-define": "error",
    "no-useless-computed-key": "error",
    "no-useless-concat": "error",
    "no-useless-constructor": "error",
    "no-useless-return": "error",
    "no-var": "error",
    "object-shorthand": "error",
    "one-var": ["error", "never"],
    "operator-assignment": "error",
    "prefer-arrow-callback": "error",
    "prefer-const": "error",
    "prefer-exponentiation-operator": "error",
    "prefer-numeric-literals": "error",
    "prefer-object-spread": "error",
    "prefer-rest-params": "error",
    "prefer-spread": "error",
    "prefer-template": "error",
    "require-await": "error",
    "spaced-comment": "error",
    curly: ["error", "multi"], // Don't use unnecessary curly braces.
    eqeqeq: "error",
    // Sort named import members alphabetically.
    "sort-imports": [
      "error",
      {
        ignoreDeclarationSort: true,
      },
    ],

    // Import Plugin
    "import/no-unused-modules": [
      "error",
      {
        missingExports: true,
        unusedExports: true,
        // Ignore scripts and tests.
        ignoreExports: ["./*.js", "test/*.js"],
      },
    ],
    // Don't allow reaching into modules, except for artifacts.
    "import/no-internal-modules": [
      "error",
      {
        allow: ["artifacts/*"],
      },
    ],
    "import/no-useless-path-segments": [
      "error",
      {
        noUselessIndex: true,
      },
    ],
    "import/extensions": "error", // Don't use unnecessary file extensions.
    "import/order": [
      "error",
      {
        "newlines-between": "always",
        alphabetize: {
          order: "asc",
        },
      },
    ],
    "import/newline-after-import": "error",
    "import/no-anonymous-default-export": [
      "error",
      {allowCallExpression: false},
    ],

    // Unicorn Plugin
    "unicorn/prevent-abbreviations": [
      "error",
      {
        replacements: {
          acc: false,
          args: false,
          arr: false,
          err: false,
          props: false,
          ref: false,
          res: false,
        },
      },
    ],
    "unicorn/no-nested-ternary": "off",
    "unicorn/no-null": "off",
    "unicorn/no-reduce": "off",
    "unicorn/catch-error-name": [
      "error",
      {
        name: "err",
      },
    ],
    "unicorn/custom-error-definition": "error",
    "unicorn/no-keyword-prefix": "error",
    "unicorn/no-unsafe-regex": "error",
    "unicorn/no-unused-properties": "error",
    "unicorn/prefer-flat-map": "error",
    "unicorn/prefer-replace-all": "error",
    "unicorn/string-content": "error",

    // Regex Plugin
    "regex/invalid": [
      "error",
      [
        'import.*(/|\\.)";', // Don't use trailing slashes or cyclic index imports.
        '"\\d+"', // Don't use numerical strings.
        "(?=.*[A-F])#[0-9a-fA-F]{1,6}", // Don't use upper case letters in hex colors.
        "eslint-disabl[e]", // Don't disable rules.
      ],
    ],
  },
};
