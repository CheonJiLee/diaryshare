//
//  ResultViewController.swift
//  DiaryShare
//
//  Created by 이천지 on 2016. 8. 19..
//  Copyright © 2016년 DS. All rights reserved.
//

import UIKit

class ResultViewController : UIViewController{
    
    @IBOutlet var resultTitle: UILabel!
    @IBOutlet var resultDate: UILabel!
    @IBOutlet var resultDescription: UILabel!
    
    var paramTitle : String = ""
    var paramDate : String = ""
    var paramDescription : String = ""
    
    override func viewDidLoad() {
        self.resultTitle.text = paramTitle
        self.resultDate.text = paramDate
        self.resultDescription.text = paramDescription
    }
}
