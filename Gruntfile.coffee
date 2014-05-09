module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    watch:
      src:
        files: 'src/*'
        tasks: ["coffee:test"]

      spec:
        files: 'spec/*'
        tasks: ["coffee:spec"]

    coffee:
      dev:
        files: [
          expand: true
          cwd: 'src'
          src: ['*.coffee']
          dest: '.tmp/'
          ext: '.js'
        ]

      test:
        options:
          bare: true

        files: [
          expand: true
          cwd: 'src'
          src: ['*.coffee']
          dest: '.tmp/'
          ext: '.js'
        ]

      spec:
        options:
          bare: true

        files: [
          expand: true
          cwd: 'spec'
          src: ['*.coffee']
          dest: '.tmp/spec/'
          ext: '.js'
        ]

  grunt.registerTask 'default', ['coffee:test', 'coffee:spec', 'watch']
