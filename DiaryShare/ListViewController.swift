//
//  ListViewController.swift
//  DiaryShare
//
//  Created by 이천지 on 2016. 8. 17..
//  Copyright © 2016년 DS. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {

    @IBOutlet var diaryListTable: UITableView!
    
    @IBOutlet var keyDate: UILabel!
    var list = Array<DiaryData>()
    @IBAction func unwindToListViewController(seque: UIStoryboardSegue){
        print("ListView입니다.")
        self.updateListView()
        self.diaryListTable.reloadData()
         
    }
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateListView()
    }
    func updateListView(){
        //테이블리스트 초기화
        self.list.removeAll()
        // 애플리케이션이 실행되면 데이터베이스 파일이 존재하는지 체크한다. 존재하지 않으면 데이터베이스파일과 테이블을 생성한다.
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        databasePath = docsDir.stringByAppendingString("/squlite_2.db")
        let contactDB = FMDatabase(path:databasePath as String)
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            // FMDB 인스턴스를 이용하여 DB 체크
            if contactDB == nil {
                print("[1] Error : \(contactDB.lastErrorMessage())")
            }
            
            // DB 오픈
            if contactDB.open(){
                // 테이블 생성처리
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS ( ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, DATE TEXT, DESCRIPTION TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("[2] Error : \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            }else{
                print("[3] Error : \(contactDB.lastErrorMessage())")
            }
        }
        else{
            contactDB.open()
            print("[1] SQLite 파일 존재!!")
            
            let querySQL = "SELECT title, date FROM CONTACTS"
            print("[Find from DB] SQL to find => \(querySQL)")
            
            let results_lab_test:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            while results_lab_test?.next() == true
            {
                let mvo = DiaryData()
                
                let titleString = results_lab_test?.stringForColumn("title")
                let dateString = results_lab_test?.stringForColumn("date")
                
                mvo.title = titleString
                mvo.date = dateString
                self.list.append(mvo)
                
            }
            contactDB.close()
            
        }

    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = self.list[indexPath.row]
        print(indexPath.row)
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell")!
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.date
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Touch Table Row at %d", indexPath.row)
        let row = self.list[indexPath.row]
        
        if let rvc = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as? ResultViewController{
            rvc.paramTitle = row.title!
            rvc.paramDate = row.date!
            rvc.paramDescription = row.description!
        }
        
////        print("'\(self.tempDate)', '(self.tempTitle)'")
////        performSegueWithIdentifier("dataView", sender: self)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let rvc = segue.destinationViewController as? ResultViewController{
//            print("222222222222")
//            rvc.paramTitle = "안녕"
//            rvc.paramDate = "안녕"
//            rvc.paramDescription = "안녕"
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
