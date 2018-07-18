const HtmlWebpackHarddiskPlugin = require('html-webpack-harddisk-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const merge = require('webpack-merge');
const path = require('path');

const devServerOptions = process.argv.find(arg => arg.includes('webpack-dev-server'))
  ? {
    devServer: { headers: { 'Access-Control-Allow-Origin': '*' } },
    output: { publicPath: 'http://0.0.0.0:8080/' },
  }
  : {};

module.exports = merge({
  entry: path.join(__dirname, 'src/index.jsx'),
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        loader: 'babel-loader',
        options: {
          presets: ['env', 'react', 'stage-0'],
        },
      },
      {
        test: /\.(css|less)$/,
        loaders: ['style-loader', 'css-loader', 'less-loader'],
      },
      {
        test: /\.(png|svg)$/,
        loaders: 'file-loader',
      },
    ],
  },
  output: {
    path: path.join(__dirname, 'public'),
    publicPath: '/',
  },
  plugins: [
    new HtmlWebpackPlugin({
      alwaysWriteToDisk: true,
      filename: 'index.html',
      template: 'src/template.html',
    }),
    new HtmlWebpackHarddiskPlugin(),
  ],
  resolve: {
    extensions: ['.js', '.jsx'],
  },
}, devServerOptions);
