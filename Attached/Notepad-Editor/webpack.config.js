const path = require('path')
const {CleanWebpackPlugin} = require('clean-webpack-plugin')
const TerserPlugin = require("terser-webpack-plugin");

module.exports = {
	mode: 'production',
	output: {
		filename: '[name].js',
		path: path.resolve(__dirname, 'dist'),
		libraryTarget: 'umd',
		library: 'Editor',
		libraryExport: 'default',
		globalObject: 'this',
	},
	entry: {
		'index.min': './src/index.ts'
	},
	optimization: {
		minimize: true,
		minimizer: [
			new TerserPlugin({
				include: ['index.min.js'],
				terserOptions: {
					format: {
						comments: false,
					},
				},
				extractComments: false,
			}),
		],
	},
	resolve: {
		extensions: ['.ts', '.js'],
	},
	module: {
		rules: [
			{
				test: /\.js$/,
				exclude: /node_modules/,
				use: [
					{
						loader: 'babel-loader',
						options: {
							presets: [
								[
									"@babel/preset-env",
									{
										targets: {
											browsers: [
												'last 2 Chrome major versions',
												'last 2 Safari major versions',
												'last 2 iOS major versions',
											]
										},
									}
								]
							]
						}
					},
				],
			},
			{
				test: /\.ts$/,
				use: 'ts-loader'
			}
		]
	},
	plugins: [
		new CleanWebpackPlugin({
			cleanOnceBeforeBuildPatterns: [
				path.join(__dirname, 'dist')],
		}),
	]
}
