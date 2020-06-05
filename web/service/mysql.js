const mysql = require('mysql')
const config = require('./config')

const pool = mysql.createPool(config.mysql)

exports.query = function(sql){
    // console.log(sql);
    return  new Promise((resolve,reject)=>{
         pool.getConnection((err,connection)=>{
            if(err) reject(err)
            connection.query(sql,(err,rows,fields)=>{
                connection.release()
                if(err)reject(err)
                else  resolve(rows)
            })
        })
    })
}