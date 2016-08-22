//
//  AddController.swift
//  DiaryShare
//
//  Created by 이천지 on 2016. 8. 17..
//  Copyright © 2016년 DS. All rights reserved.
//

import UIKit

class AddContorller : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    var dateString = ""
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var selectDatePicker: UIDatePicker!
    
    @IBAction func showDatePickerAction(sender: AnyObject) {
        selectDatePicker.hidden = false
    }
    @IBAction func selectedDateAction(sender: AnyObject) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YY-MM- hh:mma"
        
        dateString = formatter.stringFromDate((sender as! UIDatePicker).date)
        selectDateButton.setTitle(dateString, forState: UIControlState.Normal)
    }
    @IBAction func pick(sender: AnyObject) {
        //이미지 피커 컨트롤러 인스턴스 생성
        let picker = UIImagePickerController()
        //사진라이브러리 소스를 선택
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //수정가능 옵션
        picker.allowsEditing = true
        //델리게이트 지정
        picker.delegate = self
        //화면에 표시
        self.presentViewController(picker, animated: false, completion: nil)
    }
    
    var databasePath = NSString()
    @IBAction func unwindToPageListView(sender: AnyObject) {
        /*
         연락처 정보 저장
         데이터베이스 파일을 열어 텍스트 필드 3개로부터 텍스트를 추출하고 INSERT SQL문을 구성하여 DB에 저장후 DB를 close처리한다.
         */
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        databasePath = docsDir.stringByAppendingString("/squlite_2.db")
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB.open() {
            print("[Save to DB] Name : \(titleTextField.text)")
            // SQL에 데이터를 입력하기 전 바로 입력하게 되면 "Optional('')"와 같은 문자열이 text문자열을 감싸게 되므로 뒤에 !을 붙여 옵셔널이 되지 않도록 한다.
            let insertSQL = "INSERT INTO CONTACTS (title, date, description) VALUES ('\(titleTextField.text!)', '\(dateString)', '\(descriptionTextView.text!)')"
            print("[Save to DB] SQL to Insert => \(insertSQL)")
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                print("[4] Error : \(contactDB.lastErrorMessage())")
            }else{
                // DB 저장 완료후 모든 TextField 초기화 처리
                titleTextField.text = ""
            }
            contactDB.close()
        }else{
            print("[5] Error : \(contactDB.lastErrorMessage())")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        selectDatePicker.hidden = true
    }
    //키보드 처리
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //키보드 처리
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        selectDatePicker.hidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 이미지 피커 컨트롤러 창 닫기
        picker.dismissViewControllerAnimated(false, completion: nil)
        // 이미지를 이미지 뷰에 표시
        self.imgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //이미지 피커 컨트롤러 창 닫기
        picker.dismissViewControllerAnimated(false, completion: nil)
        
        //알림창 호출
        let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "확인", style: .Cancel, handler : nil))
        self.presentViewController(alert, animated: false, completion: nil)
    }
}
