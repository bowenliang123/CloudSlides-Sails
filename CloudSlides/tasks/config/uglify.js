/**
 * Minify files with UglifyJS.
 *
 * ---------------------------------------------------------------
 *
 * Minifies client-side javascript `assets`.
 *
 * For usage docs see:
 *        https://github.com/gruntjs/grunt-contrib-uglify
 *
 */
module.exports = function (grunt) {

    grunt.config.set('uglify', {

        //设置mangle属性，令uglify不会干扰angular
        //https://github.com/gruntjs/grunt-contrib-uglify#mangle
        options: {
            mangle: false
        },

        dist: {
            src: ['.tmp/public/concat/production.js'],
            dest: '.tmp/public/min/production.min.js'
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
};
