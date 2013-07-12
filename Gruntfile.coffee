module.exports = (grunt) ->
  sourceFiles = [
    'src/app/treeView.coffee'
    'src/app/treeNode.coffee'
  ]
  grunt.initConfig
    concat:
      dist:
        src: sourceFiles
        dest: 'temp/dist.coffee'
    coffee:
      app:
        files:
          'dist/app/backbonetree.js': sourceFiles
      prod:
        files:
          'dist/app/backbonetree.dist.js': 'temp/dist.coffee'
    compass:
      app:
        options:
          sassDir: 'src/style'
          cssDir: 'dist/style'
    uglify:
      dist:
        files:
          'dist/app/backbonetree.min.js': ['dist/app/backbonetree.dist.js']
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
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.registerTask 'default', ['coffee:app', 'compass:app', 'watch']
  grunt.registerTask 'deploy', ['concat:dist', 'coffee:prod', 'compass:app', 'uglify:dist']