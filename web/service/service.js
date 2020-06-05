const dao = require('./dao')
var run = require("sync-runner")

const nodemailer = require('nodemailer');
let transporter = nodemailer.createTransport({
  service: '163', 
  port: 465,
  secureConnection: true, 
  auth: {
    user: 'shang_qingdong@163.com',
    pass: 'qwer1234',
  }
});

exports.write_input = async (ctx,next)=>{
    console.log(ctx)
    console.log(ctx.request.body)
    let email = ctx.request.body.email
	let code = ctx.request.body.code
    let dt = await dao.email_code(email,code)
	if (dt[0].c == 1) {
		//var result = run("cleos system newaccout --stake-net '1 EOS' --stake-cpu '2 EOS' --buy--ram--kbytes 250 cateateAcc.. ")
		//console.log(result)
		await dao.write_user(ctx.request.body.pk1,ctx.request.body.pk2,email,ctx.request.body.name)
		ctx.body = {
        msg:'OK',
        code:200,
        data:{}
    	};
	} else {
		ctx.body = {
        msg:'注册失败',
        code:200,
        data:{}
    	};
	}
}


function randomNum(minNum,maxNum){ 
    switch(arguments.length){ 
        case 1: 
            return parseInt(Math.random()*minNum+1,10); 
        break;
        case 2:
            return parseInt(Math.random()*(maxNum-minNum+1)+minNum,10); 
        break; 
            default: 
                return 0; 
            break; 
    } 
} 

exports.post_code = async (ctx,next)=>{
    console.log(ctx)
    console.log(ctx.request.body)
    let email = ctx.request.body.email;
	let dt = await dao.can_regisuer(email)
	if (dt[0].c == 1){
		ctx.body = {
        msg:'邮箱已经使用',
        code:200,
        data:{}
    	};
	} else {
		let r = randomNum(100000,1000000)
		let mailOptions = {
  			from: '"bes_user" <shang_qingdong@163.com>',
  			to: email,
  			subject: "regisuer bes user",
  			html: '<b>' + r.toString() + '</b>'}

		transporter.sendMail(mailOptions, (error, info) => {
  			if (error) {
    			return console.log(error);
  			}
  			console.log('Message sent: %s', info.messageId);
		});
		await dao.regisuer(email,r.toString())
		ctx.body = {
	        msg:'ok',
        	code:200,
        	data:{}
    	};
	}
}
