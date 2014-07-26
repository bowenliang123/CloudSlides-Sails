module.exports = function (grunt) {
    grunt.registerTask('compileAssets', [
        'clean:dev',
//        'jst:dev',
//        'less:dev',
        'copy:dev'
//		,'coffee:dev'
        //关闭sails中使用gunt对coffee脚本进行编译
    ]);
};
