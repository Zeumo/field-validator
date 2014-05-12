module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    watch:
      src:
        files: 'src/*'
        tasks: ['coffee:dist', 'jasmine', 'concat']

      spec:
        files: 'spec/*'
        tasks: ['coffee:spec', 'jasmine']

    coffee:
      dist:
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

    jasmine:
      spec:
        src: '.tmp/*.js',
        options:
          display: 'short'
          summary: true
          keepRunner: true
          specs: '.tmp/spec/*Spec.js',
          helpers: '.tmp/spec/*Helper.js'
          vendor: [
            'node_modules/jquery/dist/jquery.js'
            'node_modules/lodash/lodash.js'
          ]

    concat:
      options:
        banner: "
/*  <%= pkg.name %> <%= pkg.version %> (<%= grunt.template.today('yyyy-mm-dd') %>)\n
 *  <%= pkg.description %>\n
 *  <%= pkg.license %> License\n
 */\n\n
"
      dist:
        src: '.tmp/<%= pkg.name %>.js'
        dest: 'dist/<%= pkg.name %>.js'

  grunt.registerTask 'default', ['coffee:dist', 'coffee:spec', 'jasmine', 'watch']
  grunt.registerTask 'dist', ['coffee:dist', 'concat']
