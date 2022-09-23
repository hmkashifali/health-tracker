module.exports = {
  test: /\.s(c|a)ss$/,
  use: [
    'vue-style-loader',
    'css-loader',
    'sass-loader'
  ]
}
