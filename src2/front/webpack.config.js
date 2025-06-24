// Generated using webpack-cli https://github.com/webpack/webpack-cli

const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const isProduction = process.env.NODE_ENV === "production";

const stylesHandler = MiniCssExtractPlugin.loader;

const config = {
  entry: "./frontend/src/index.jsx",
  output: {
    path: path.resolve(__dirname, "frontend", "dist"),
  },
  devServer: {
    open: true,
    host: "localhost",
    historyApiFallback: true, // 🔥 This tells dev server to serve index.html for all routes
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "frontend/index.html",
    }),

    new MiniCssExtractPlugin(),

    // Add your plugins here
    // Learn more about plugins from https://webpack.js.org/configuration/plugins/
  ],
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env", "@babel/preset-react"],
          },
        },
      },
      {
        test: /\.css$/i,
        use: [isProduction ? MiniCssExtractPlugin.loader : "style-loader", "css-loader", "postcss-loader"],
      },
      {
        test: /\.(eot|svg|ttf|woff|woff2|png|jpg|gif)$/i,
        type: "asset",
      },

      // Add your rules for custom modules here
      // Learn more about loaders from https://webpack.js.org/loaders/
    ],
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./frontend/src/"),
    },
    extensions: [".jsx", ".js", ".tsx", ".ts", ".json"],
  },
};

module.exports = () => {
  if (isProduction) {
    config.mode = "production";
  } else {
    config.mode = "development";
  }
  return config;
};
