module.exports = {
  "presets": [
    [
      "@babel/preset-env", {
      "useBuiltIns": "usage",
      "targets": {
        "browsers": "> 1%",
        "uglify": true,
        "node": "current",
      },
    }],
  ],

  "plugins": [
    "@babel/plugin-proposal-class-properties",
  ],
};
