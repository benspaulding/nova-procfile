module.exports = {
	root: true,
	parser: "@typescript-eslint/parser",
	parserOptions: {
		ecmaFeatures: {
			impliedStrict: true,
		},
		ecmaVersion: 2019,
		sourceType: "module",
	},
	env: {
		es2017: true,
		mocha: true,
		node: true,
	},
	plugins: ["@typescript-eslint", "prettier"],
	extends: [
		"plugin:@typescript-eslint/recommended",
		"prettier/@typescript-eslint",
		"plugin:prettier/recommended",
	],
};
