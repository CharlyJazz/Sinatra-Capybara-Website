const path = require('path')

module.exports = {
  entry: "./assets/coffeescript/app.coffee",
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, "./assets/javascripts"),
  },
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [ 'coffee-loader' ]
      }
    ]
  }
}