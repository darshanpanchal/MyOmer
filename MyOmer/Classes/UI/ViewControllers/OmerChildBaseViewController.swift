//
//  OmerChildBaseViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/7/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class OmerChildBaseViewController: UIViewController {
    
    open var week: OmerWeek?
    open var day: OmerDay?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged), name: .omerDayChanged, object: nil)
    }
    
    @objc func dayChanged(notification: NSNotification) {
        print("dayChanged")
    }
    
    // MARK: - Memory Cleanup Methods
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
