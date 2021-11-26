//
//  JournalViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/7/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class JournalViewController: OmerChildBaseViewController {
    
    @IBOutlet weak var parentView: UIView!
    var pvc: QuestionPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func dayChanged(notification: NSNotification) {
        week = notification.userInfo!["week"]! as? OmerWeek
        day = notification.userInfo!["day"]! as? OmerDay
        refresh()
    }
    
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension JournalViewController {
    
    func refresh() {
        if pvc != nil {
            pvc?.removeFromParent()
            pvc?.view.removeFromSuperview()
        }
        pvc = QuestionPageViewController(week: week!, day: day!)
        addChild(pvc!)
        pvc?.view.frame = parentView.frame
        pvc?.didMove(toParent: self)
        parentView.addSubview((pvc?.view)!)
    }
}
