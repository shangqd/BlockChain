package main
import (
	"database/sql"
	"fmt"
	_"github.com/go-sql-driver/mysql"
)

type DbWorker struct {
	Dsn      string
	Db       *sql.DB
	UserInfo userTB
}

type userTB struct {
	Id   int
	Name sql.NullString
	Age  sql.NullInt64
}

func (dbw *DbWorker) insertData() {
	stmt, _ := dbw.Db.Prepare(`INSERT INTO user (name, age) VALUES (?, ?)`)
	defer stmt.Close()
	ret, err := stmt.Exec("尚庆东1", 123)
	if err != nil {
		fmt.Printf("insert data error: %v\n", err)
		return
	}
	if LastInsertId, err := ret.LastInsertId(); nil == err {
		fmt.Println("LastInsertId:", LastInsertId)
	}
	if RowsAffected, err := ret.RowsAffected(); nil == err {
		fmt.Println("RowsAffected:", RowsAffected)
	}
}

func (dbw *DbWorker) QueryDataPre() {
	dbw.UserInfo = userTB{}
}

func (dbw *DbWorker) queryData() {
	stmt, _ := dbw.Db.Prepare(`SELECT * From user where age >= ? AND age < ?`)
	defer stmt.Close()
	dbw.QueryDataPre()
	rows, err := stmt.Query(20, 1000)
	defer rows.Close()
	if err != nil {
		fmt.Printf("insert data error: %v\n", err)
		return
	}
	for rows.Next() {
		rows.Scan(&dbw.UserInfo.Id, &dbw.UserInfo.Name, &dbw.UserInfo.Age)
		if err != nil {
			fmt.Printf(err.Error())
			continue
		}
		if !dbw.UserInfo.Name.Valid {
			dbw.UserInfo.Name.String = ""
		}
		if !dbw.UserInfo.Age.Valid {
			dbw.UserInfo.Age.Int64 = 0
		}
		fmt.Println("get data, id: ", dbw.UserInfo.Id, " name: ", dbw.UserInfo.Name.String, " age: ", int(dbw.UserInfo.Age.Int64))
	}
	err = rows.Err()
	if err != nil {
		fmt.Printf(err.Error())
	}
}


func db_test() {
	var err error
	dbw := DbWorker{
		Dsn: "root:root@tcp(localhost:3306)/eos?charset=utf8mb4",
	}
	dbw.Db, err = sql.Open("mysql", dbw.Dsn)
	if err != nil {
		panic(err)
		return
	}
	defer dbw.Db.Close()

	dbw.insertData()
	dbw.queryData()
}