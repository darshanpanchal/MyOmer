//
//  WaitingOmerViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/1/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import Firebase

class WaitingOmerViewController: UIViewController {
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    
    var omerCalendar: OmerCalendar?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let oc = omerCalendar {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE 'night', MMMM d, yyyy"
            formatter.timeZone = TimeZone.current
            startDateLabel.text = formatter.string(from: oc.startDate)
            daysLeftLabel.text = "\(oc.daysLeft)"
        }
    }
    
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WaitingOmerViewController {
    
    @IBAction func getTheBookButton_Pressed(_ sender: Any) {
        if let url = URL(string: Config.URL.bookUrl) {
            if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                Analytics.logEvent("User_Buy_Book", parameters:["Email":"\(userEmail)"])
            }
            openWebView(title: "Get the Book", url: url)
        }
    }
    
    @IBAction func whatIsOmerButton_Pressed(_ sender: Any) {
        openNavigator(withIdentifier: "AboutUsNavigator")
    }
    
    @IBAction func settingsButton_Pressed(_ sender: Any) {
        openNavigator(withIdentifier: "SettingsNavigator")
    }
}

extension WaitingOmerViewController {
    
    func openNavigator(withIdentifier identifier: String) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        let omerChartNavigator = storyboard?.instantiateViewController(withIdentifier: identifier) as! UINavigationController
        present(omerChartNavigator, animated: false, completion: nil)
    }
    
    func openWebView(title: String, url: URL) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        let webNavigator = storyboard?.instantiateViewController(withIdentifier: "WebNavigator") as! UINavigationController
        let webVC = webNavigator.viewControllers[0] as! WebViewController
        webVC.title = title
        webVC.url = url
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }

        //present(webNavigator, animated: false, completion: nil)
    }
}
