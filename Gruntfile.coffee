# Gruntfile.coffee
module.exports = taskManager = (grunt) ->
  # Initialize
  grunt.initConfig
    config:
      package: grunt.file.readJSON 'package.json'
      bower:   grunt.file.readJSON 'bower.json'

    # contrib-clean config
    # (https://github.com/gruntjs/grunt-contrib-clean/blob/master/README.md)
    clean: [
      # Ignored files.
      'lib/**'
      'vendor/**'
      'components/**'

      # Previous builds.
      'build/**'
    ]

    # bower-task config
    # (https://github.com/yatskevich/grunt-bower-task/blob/master/README.md)
    bower:
      install:
        options:
          targetDir: 'vendor'
          layout:    'byType'
          install:   true
          cleanup:   true

    # contrib-coffee config
    # (https://github.com/gruntjs/grunt-contrib-coffee/blob/master/README.md)
    coffee:
      compile:
        options:
          bare: true

        # Dynamically select files. (http://gruntjs.com/configuring-tasks#building-the-files-object-dynamically)
        expand: true
        cwd:  'src'

        src:  ['**/*.coffee']
        dest: 'lib/'
        ext:  '.js'

    # contrib-jshint config
    # (https://github.com/gruntjs/grunt-contrib-jshint/blob/master/README.md)
    jshint:
      all: ['lib/**/*.js']

    # browserify config
    # (https://github.com/jmreidy/grunt-browserify/blob/master/README.md)
    browserify:
      all:
        src:  ['lib/index.js']
        dest: 'build/<%= config.bower.name %>-<%= config.bower.version %>.js'
        options:
          # Add global aliases for browserify modules.
          # Format: 'path/to/file.js:alias'
          alias: [
            'vendor/eventEmitter/EventEmitter.js:EventEmitter'
            'vendor/peerjs/dist/peer.js:Peer'

            'vendor/modernizr/modernizr.js:modernizr'
            'vendor/underscore/underscore.js:_'
          ]

    # contrib-uglify config
    # (https://github.com/gruntjs/grunt-contrib-uglify/blob/master/README.md)
    uglify:
      options:
        banner: '/*! <%= config.bower.name %>-<%= config.bower.version %>
         Built: <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      all:
        src:  'build/<%= config.bower.name %>-<%= config.bower.version %>.js'
        dest: 'build/<%= config.bower.name %>-<%= config.bower.version %>.min.js'

    # contrib-copy config
    # (https://github.com/gruntjs/grunt-contrib-copy/blob/master/README.md)
    copy:
      builds:
        files: [
          {
            src:  'build/<%= config.bower.name %>-<%= config.bower.version %>.js'
            dest: '<%= config.bower.name %>.js'
          }, {
            src:  'build/<%= config.bower.name %>-<%= config.bower.version %>.min.js'
            dest: '<%= config.bower.name %>.min.js'
          }
        ]

    # contrib-watch config
    # (https://github.com/gruntjs/grunt-contrib-watch/blob/master/README.md)
    watch:
      files: 'src/**/*.coffee'
      tasks: ['default']

  # Load npm tasks.
  modules = getKeys (grunt.config 'config.package').devDependencies
  plugins = ( module for module in modules when !!~module.indexOf 'grunt-' )

  grunt.loadNpmTasks plugin for plugin in plugins

  # Register custom tasks.
  grunt.registerTask 'setup',   ['clean', 'bower:install']
  grunt.registerTask 'compile', ['coffee', 'jshint']
  grunt.registerTask 'build',   ['browserify', 'uglify', 'copy']

  grunt.registerTask 'all',     ['setup', 'compile', 'build']
  grunt.registerTask 'default', ['compile', 'build']

# Utils
getKeys = (obj) -> key for own key, value of obj
