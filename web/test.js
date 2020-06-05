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

let mailOptions = {
  from: '"xiao yan ma" <shang_qingdong@163.com>',
  to: 'shang_qd@qq.com',
  subject: 'xiao yan ma',
  html: '<b>123456</b>'
};

transporter.sendMail(mailOptions, (error, info) => {
  if (error) {
    return console.log(error);
  }
  console.log('Message sent: %s', info.messageId);
});
