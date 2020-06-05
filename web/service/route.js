const router = require('koa-router')()
const s = require('./service')

//接口文件

router.all('/input',s.write_input)

router.all('/post_code',s.post_code)

module.exports = router;
