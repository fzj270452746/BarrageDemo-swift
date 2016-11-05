//
//  ViewController.swift
//  BarrageDemo
//
//  Created by Fan on 16/10/31.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var barrageManager:FFBarrageManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.gray
        
        barrageManager = FFBarrageManager().initWithComments(comments: ["弹幕1~~~~~~~", "弹幕2~~~~~~~~~~~~~~~~~~",
                                                                        "弹幕3~~~~~~~~~~~~~~~~~~", "弹幕4~~~~~~~~~~~~",
                                                                        "弹幕5~~~~~~~~~~~~", "弹幕6~~~~~~~~~~~~~",
                                                                        "弹幕7~~~~~~~~~~~", "弹幕8~~~~~~~~~~", "弹幕9~~~~~~~~~~~~~~"])
        //设置弹幕轨道个数
        barrageManager?.trajectoryCount = 4
        barrageManager?.generateView = { [weak self](barrageView)  in
            //通过回调设置barrageView的frame，并把其加在controller.view
            barrageView.frame = CGRect(x: UIScreen.main.bounds.size.width, y: CGFloat(200 + barrageView.trajectory * 50), width: barrageView.frame.size.width, height: barrageView.frame.size.height)
            self?.view.addSubview(barrageView)
            
            barrageView.startAnimation()
        }
    }

    @IBAction func Start(_ sender: AnyObject) {
        barrageManager?.start()
    }
    
    @IBAction func stop(_ sender: AnyObject) {
        barrageManager?.stop()
    }
    
    @IBAction func append(_ sender: AnyObject) {
        var data:[String] = []
        for _ in 0...10 {
            let value = arc4random()%1000
            data.append("弹幕\(value)~~~~~~~~~~~~~")
        }
        barrageManager?.appendComments(appendComments: data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

