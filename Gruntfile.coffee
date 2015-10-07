module.exports = (grunt) ->
# Load grunt tasks automatically
    require('load-grunt-tasks') grunt

    webpack = require("webpack")
    webpackConfig = require("./webpack.config.js")

    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        clean:
            dev: [ 'temp', 'js' ]
            dist: [ 'dist' ]
        watch:
            options: livereload: true
            files: [
                'coffee/**/*.coffee'
                'test/coffee/**/*.coffee'
            ]
            tasks: [ 'dev' ]
        connect:
            options:
                port: 8080
                hostname: 'localhost'
                open: true
            server: options: keepalive: true
            livereload: options: livereload: true
        coffee:
            source:
                expand: true
                flatten: true
                cwd: 'coffee'
                src: [ '**/*.coffee' ]
                dest: 'js'
                ext: '.js'
            test:
                expand: true
                flatten: true
                cwd: 'test/coffee'
                src: [ '**/*.coffee' ]
                dest: 'temp/test/js'
                ext: '.js'
        jasmine: all:
            options:
                specs: [
                    'temp/test/js/**/*Spec.js'
                ]
#                vendor: [
#                    'vendor/jquery.min.js'
#                    'vendor/lodash.js'
#                ]
                keepRunner: true
            src: 'js/**/*.js'
        webpack:
            options: webpackConfig
            build:
                plugins: webpackConfig.plugins.concat(
                  new webpack.DefinePlugin(
                      "process.env":
                          # This has effect on the react lib size
                          "NODE_ENV": JSON.stringify("production")

                  ),
                  new webpack.optimize.DedupePlugin(),
                  new webpack.optimize.UglifyJsPlugin()
                )
            ,
            "dev":
                devtool: "sourcemap",
                debug: true
    grunt.registerTask 'dev', [
        'clean:dev'
        'webpack:dev'
        'jasmine:all:build'
    ]
    grunt.registerTask 'server', [
        'dev'
        'connect:server'
    ]
    grunt.registerTask 'livereload', [
        'dev'
        'connect:livereload'
        'watch'
    ]
    grunt.registerTask 'test', [
        'clean:dev'
        'coffee'
        'jasmine:all'
    ]
    grunt.registerTask 'default', [ 'dev' ]
