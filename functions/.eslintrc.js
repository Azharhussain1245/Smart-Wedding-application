module.exports = {
  env: {
    node: true,
    es2021: true,
  },
  extends: [
    'eslint:recommended',
    'google',
  ],
  rules: {
    indent: 'off',
    'max-len': 'off',
    'comma-dangle': 'off',
    'quote-props': 'off',
    'object-curly-spacing': 'off',
    'prefer-arrow-callback': 'off',
    'space-before-function-paren': 'off',
    'no-multiple-empty-lines': 'off',
    quotes: 'off',
  },
};




// module.exports = {
//   env: {
//     es6: true,
//     node: true,
//   },
//   parserOptions: {
//     "ecmaVersion": 2018,
//   },
//   extends: [
//     "eslint:recommended",
//     "google",
//   ],
//   rules: {
//     "no-restricted-globals": ["error", "name", "length"],
//     "prefer-arrow-callback": "error",
//     "quotes": ["error", "double", {"allowTemplateLiterals": true}],
//   },
//   overrides: [
//     {
//       files: ["**/*.spec.*"],
//       env: {
//         mocha: true,
//       },
//       rules: {},
//     },
//   ],
//   globals: {},
// };
