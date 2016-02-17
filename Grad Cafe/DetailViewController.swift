//
//  DetailViewController.swift
//  Grad Cafe
//
//  Created by Gohar Irfan on 2/17/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var institution: UILabel!
    @IBOutlet weak var program_season: UILabel!
    @IBOutlet weak var decision: UILabel!
    @IBOutlet weak var date_added: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var notes: UILabel!
    

    var detailItem: Entry? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label1 = self.institution {
                label1.text = detail.institution
            }
            
            if let label2 = self.program_season {
                label2.text = detail.program_season
            }
            
            if let label3 = self.decision {
                label3.text = detail.decision
                if (detail.decision.containsString("Accept")) {
                    label3.textColor = UIColor.greenColor()
                } else if (detail.decision.containsString("Reject")) {
                    label3.textColor = UIColor.redColor()
                }
            }

            if let label4 = self.date_added {
                label4.text = detail.date_added
            }

            if let label5 = self.status {
                label5.text = detail.status
            }
            
            if let label6 = self.notes {
                label6.text = detail.notes
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

