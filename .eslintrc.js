module.exports = {
	root: true,
	parser: "@typescript-eslint/parser",
	parserOptions: {
		ecmaFeatures: {
			impliedStrict: true,
		},
		ecmaVersion: 2020,
		lib: ["ES2020"],
		sourceType: "module",
	},
	env: {
		es2020: true,
		jest: true,
		node: true,
	},
	plugins: ["@typescript-eslint", "prettier"],
	extends: [
		"eslint:recommended",
		"plugin:@typescript-eslint/recommended",
		"plugin:prettier/recommended",
	],
	rules: {
		"@typescript-eslint/naming-convention": "warn",
		"@typescript-eslint/no-use-before-define": "off",
		"@typescript-eslint/semi": "warn",
		curly: "warn",
		eqeqeq: "warn",
		"no-throw-literal": "warn",
		semi: "off",
	},
};
