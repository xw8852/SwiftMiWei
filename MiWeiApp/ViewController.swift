//
//  ViewController.swift
//  MiWeiApp
//
//  Created by 肖伟 on 2018/2/1.
//  Copyright © 2018年 肖伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cgView = AlarmPreviewView.init(
            frame: CGRect.init(
                x:  (self.view.frame.width-300)/2,
                y: 100,
                width: 300,
                height: 300
            )
        )
        cgView.backgroundColor = UIColor.white
       self.view.addSubview(cgView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

