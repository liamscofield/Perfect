//
//  FourthViewController.swift
//  Perfect
//
//  Created by limao on 16/5/27.
//  Copyright © 2016年 limao. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {

    var fourthTableViewController : FourthTableViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fourthTableViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FourthTableViewController") as! FourthTableViewController
        self.addChildViewController(fourthTableViewController)
        view.addSubview(fourthTableViewController.view)
        fourthTableViewController.view.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
