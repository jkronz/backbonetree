module.exports = (grunt) ->
  sourceFiles = [
    'src/app/treeView.coffee'
    'src/app/treeNode.coffee'
  ]
  grunt.initConfig
    coffee:
      app:
        files:
          'dist/app/backbonetree.js': sourceFiles
    compass:
      app:
        options:
          sassDir: 'src/style'
          cssDir: 'dist/style'
    watch:
      scripts:
        files: 'src/app/**/*.coffee'
        tasks: ['coffee:app']
      css:
        files: 'src/style/**/*.scss'
        tasks: ['compass:app']
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.registerTask 'default', ['coffee:app', 'compass:app', 'watch']