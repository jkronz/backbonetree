module.exports = (grunt) ->
  sourceFiles = [
    'src/app/treeView.coffee'
    'src/app/treeNode.coffee'
  ]
  staticSourceFiles = [
    'src/app/staticTree.coffee'
    'src/app/staticTreeNode.coffee'
  ]
  grunt.initConfig
    concat:
      dist:
        src: sourceFiles
        dest: 'temp/dist.coffee'
      static:
        src: staticSourceFiles
        dest: 'temp/staticdist.coffee'
    coffee:
      app:
        files: [
          'dist/app/backbonetree.js': sourceFiles
          'dist/app/statictree.js': staticSourceFiles
        ]
      prod:
        files: [
          'dist/app/backbonetree.dist.js': 'temp/dist.coffee'
          'dist/app/statictree.dist.js': 'temp/staticdist.coffee'
        ]

    compass:
      app:
        options:
          sassDir: 'src/style'
          cssDir: 'dist/style'
    uglify:
      dist:
        files:
          'dist/app/backbonetree.min.js': ['dist/app/backbonetree.dist.js']
          'dist/app/statictree.min.js': ['dist/app/statictree.dist.js']
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
  grunt.registerTask 'deploy', ['concat:dist', 'concat:static', 'coffee:prod', 'compass:app', 'uglify:dist']