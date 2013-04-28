# Gruntfile.coffee
module.exports = taskManager = (grunt) ->
  # Initialize
  grunt.initConfig
    package: grunt.file.readJSON 'package.json'
    bower:   grunt.file.readJSON 'bower.json'

    # contrib-coffee config
    coffee:
      compile:
        options:
          bare: true

        expand: true

        cwd:  'src'
        src:  ['*.coffee']
        dest: 'lib/'
        ext:  '.js'

  # Load npm tasks and register custom ones.
  grunt.loadNpmTasks 'grunt-contrib'

  grunt.registerTask 'compile', ['coffee']
  grunt.registerTask 'default', ['compile']
