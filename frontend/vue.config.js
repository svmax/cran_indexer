 /* eslint-disable */
const path = require('path');

module.exports = {
  lintOnSave: false,
  runtimeCompiler: true,
  filenameHashing: false,
  publicPath: process.env.VUE_APP_SOURCE_HOST,
  devServer: {
    historyApiFallback: {
      rewrites: [
        { from: /^\/$/, to: '/' },
      ],
    },
  },
  chainWebpack: config => {
    const IS_VENDOR = /[\\/]node_modules[\\/]/;
    config.optimization.splitChunks({
      cacheGroups: {
        index: {
          name: 'chunk-index-vendors',
          chunks: chunk => chunk.name === 'index',
          test: IS_VENDOR,
          priority: -11,
          enforce: true,
        },
        banner: {
          name: 'chunk-banner-vendors',
          chunks: chunk => chunk.name === 'banner',
          test: IS_VENDOR,
          priority: -11,
          enforce: true,
        },
        common: {
          name: 'chunk-common',
          priority: -20,
          chunks: 'initial',
          minChunks: 2,
          reuseExistingChunk: true,
          enforce: true,
        },
      },
    });
  },
  pages: {
    index: {
      entry: 'src/packs/application.js',
      template: 'public/index.html',
      filename: 'index.html',
      chunks: ['chunk-vendors', 'chunk-common', 'chunk-index-vendors', 'index'],
    },
  },
  css: {
    extract: {
      filename: '[name].[hash:8].css',
      chunkFilename: '[name].[hash:8].css',
    },
  },
  configureWebpack: {
    output: {
      filename: '[name].[hash:8].js'
    },
    resolve: {
      alias: {
        "~": path.resolve(__dirname, 'src'),
        "packs": path.resolve(__dirname, "src/packs"),
        "views": path.resolve(__dirname, "src/views"),
        "store": path.resolve(__dirname, "src/store"),
        "assets": path.resolve(__dirname, "src/assets"),
        "helpers": path.resolve(__dirname, "src/helpers"),
        "components": path.resolve(__dirname, "src/components"),
        "node_modules": path.resolve(__dirname, "node_modules"),
        "store-modules": path.resolve(__dirname, "src/store/modules"),
        "store-mixins": path.resolve(__dirname, "src/store/modules/mixins"),
      },
    },
  },
};