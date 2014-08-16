//
//  ViewController.swift
//  weatherApp
//
//  Created by Lin wei-chih on 2014/8/16.
//  Copyright (c) 2014年 Lin wei-chih. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var api: String = ""
    
    //IBOutlet let storyBoard view Control can see the string
    @IBOutlet var city: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.city.text = "Taipei"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

