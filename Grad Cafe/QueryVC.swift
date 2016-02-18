//
//  QueryVC.swift
//  Grad Cafe
//
//  Created by Gohar Irfan on 2/17/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class QueryVC: UIViewController, UITextFieldDelegate {
    
    let prefs = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var query: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let queryStr = prefs.valueForKey("QUERY") as? String
        if queryStr != nil {
            query.text = queryStr
        }
        
        // for closing keyboard on return key press
        self.query.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func goAction(sender: UIButton) {
        prefs.setValue(query.text, forKey: "QUERY")
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.askQuery = false
        delegate.setupRootViewController(true)
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let master:MasterViewController = segue.destinationViewController as! MasterViewController
//        master.queryStr = query.text
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
