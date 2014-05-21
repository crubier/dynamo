'use strict'

module.exports = (grunt)->

  # load all grunt tasks
  (require 'matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  _ = grunt.util._
  path = require 'path'

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffeelint:
      gruntfile:
        src: '<%= watch.gruntfile.files %>'
      lib:
        src: '<%= watch.lib.files %>'
      frontend:
        src: '<%= watch.frontend.files %>'
      backend:
        src: '<%= watch.backend.files %>'
      test:
        src: '<%= watch.test.files %>'
      options:
        no_trailing_whitespace:
          level: 'warn'
        max_line_length:
          level: 'warn'
    coffee:
      lib:
        expand: true
        cwd: 'src/lib/'
        src: ['**/*.coffee']
        dest: 'out/lib/'
        ext: '.js'
      frontend:
        expand: true
        cwd: 'src/frontend/'
        src: ['**/*.coffee']
        dest: 'out/frontend'
        ext: '.js'
      backend:
        expand: true
        cwd: 'src/backend/'
        src: ['**/*.coffee']
        dest: 'out/backend/'
        ext: '.js'
      test:
        expand: true
        cwd: 'src/test/'
        src: ['**/*.coffee']
        dest: 'out/test/'
        ext: '.js'
    mochaTest:
      test:
        options:
          globals: ['should']
          reporter: 'spec'
          ui: 'bdd'
          clearRequireCache: true
          ignoreLeaks: false
          timeout: 3000
        src: [
          'node_modules/should/should.js'
          'out/test/**/*.js'
        ]
    watch:
      options:
        spawn: false
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: ['coffeelint:gruntfile']
      frontendhtml:
        files: ['src/frontend/**/*.html']
        tasks: ['sync:frontendhtml']
      frontend:
        files: ['src/frontend/**/*.coffee']
        tasks: ['coffeelint:frontend', 'browserify', 'mochaTest']
      backend:
        files: ['src/backend/**/*.coffee']
        tasks: ['coffeelint:backend', 'coffee:backend', 'mochaTest']
      lib:
        files: ['src/lib/**/*.coffee']
        tasks: ['coffeelint:lib', 'coffee:lib', 'mochaTest']
      test:
        files: ['src/test/**/*.coffee']
        tasks: ['coffeelint:test', 'coffee:test', 'mochaTest']
    browserify:
      frontend:
        files:
          'out/frontend/frontend.js': [
            'out/frontend/**/*.js','out/lib/**/*.js'
          ]
        options:
          transform: ['coffeeify', 'uglifyify']
    sync:
      frontendhtml:
        files:[
          {
            cwd: 'src/'
            src: '**/*.html'
            dest: 'out/'
          }
        ]
        verbose:true
        expand: true
    clean: ['out/']

  grunt.event.on 'watch', (action, files, target)->
    grunt.log.writeln "#{target}: #{files} has #{action}"

    # coffeelint
    grunt.config ['coffeelint', target], src: files

    # coffee
    coffeeData = grunt.config ['coffee', target]
    if coffeeData?
      files = [files] if _.isString files
      files = files.map (file)-> path.relative coffeeData.cwd, file
      coffeeData.src = files
      grunt.config ['coffee', target], coffeeData

  # tasks.
  grunt.registerTask 'compile', [
    'coffeelint'
    'coffee'
    'browserify'
    'sync'
  ]

  grunt.registerTask 'test', [
    'mochaTest'
  ]

  grunt.registerTask 'default', [
    'compile'
    'test'
  ]
