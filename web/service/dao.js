const mysql = require('./mysql')

exports.write_user = async (pk1,pk2,email,name)=>{
    let sql = "update eos_user set state = 1, pk1 = '" + pk1 + "', pk2 = '" + pk2 + "',name = '"+ name +"' where email = '" + email + "'"
    return await mysql.query(sql)
}

exports.email_code = async (email,code) => {
    let sql = "select count(*) as c from eos_user where state = 0 and email = '" +  email + "' and code = '" + code + "'" 
    return await mysql.query(sql)
}

exports.can_regisuer = async (email) => {
    let sql = "select count(*) as c from eos_user where email = '" +  email + "' and state = 1"
    return await mysql.query(sql)
}

exports.regisuer = async (email,code) => {
    let sql = "call register_user('" + email + "','" + code + "')"
    return await mysql.query(sql)
}
