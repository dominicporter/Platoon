var webpack = require("webpack");

module.exports = {
    entry: {
        main : "./coffee/game.coffee"
    },
    output: {
        path: "js",
        filename: "[name].bundle.js"
    },
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee-loader" }
            //{ test: /\.css$/, loader: "style!css" }
        ]
    },
    resolve: {
        extensions: ["", ".coffee", ".js"],
        alias       : {
            nodash      : __dirname + '/scripts/coffee/experimental/functional/nodash',
            config      : __dirname + '/scripts/coffee/experimental/configuration/configuration',
            mula        : __dirname + '/scripts/coffee/experimental/mula/mula',
            observer    : __dirname + '/scripts/coffee/experimental/observer/observer'
        }
    },
    plugins: [
        new webpack.ProvidePlugin({
            // Automtically detect jQuery and $ as free var in modules
            // and inject the jquery library
            // This is required by many jquery plugins
            jQuery: "jquery",
            $: "jquery"
        })
    ]
};