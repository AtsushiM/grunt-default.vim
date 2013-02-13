module.exports = function(grunt) {
    grunt.initConfig({
        min: {
            rulename: {
                src: ['js/src/part.js'],
                dest: 'js/min.js'
            }
        },
        watch: {
            files: [
                'js/src/**/*'
            ],
            tasks: 'min'
        }
    });

    grunt.registerTask('default', 'watch');
};
