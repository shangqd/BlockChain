const Koa = require('koa')
const bodyParser = require('koa-bodyparser')
const path = require('path')
const cors = require('koa2-cors')
const router = require('./service/route.js')
const static = require('koa-static')
const logger = require('koa-logger')
const app =module.exports= new Koa()

app.use(logger());


app.use(static(path.join(__dirname,'./web')))


app.use(bodyParser()).use(cors())
app.use(router.routes(),router.allowedMethods())


app.on('err',(err,ctx)=>{
    console.error('server error',err,ctx)
})
app.on('unhandledRejection',(err, ctx) =>
  console.error('server unhandledRejection', err, ctx)
);
app.listen('5000',()=>{
    console.log('koa server is start at port 5000')
})