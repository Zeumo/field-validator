module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    watch:
      src:
        files: 'src/*'
        tasks: ['coffee:dist', 'concat']

      spec:
        files: 'spec/*'
        tasks: ['coffee:spec']

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

    concat:
      options:
        banner: "
/*\n
<%= pkg.name %> <%= pkg.version %>\n
<%= pkg.description %>\n
<%= pkg.license %>\n
<%= grunt.template.today('yyyy-mm-dd') %>\n
*/\n
        "
      dist:
        src: '.tmp/<%= pkg.name %>.js'
        dest: 'dist/<%= pkg.name %>.js'

  grunt.registerTask 'default', ['coffee:dist', 'coffee:spec', 'watch']
  grunt.registerTask 'dist', ['coffee:dist', 'concat']
