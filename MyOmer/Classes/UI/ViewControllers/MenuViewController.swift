//
//  MenuViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/3/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import MessageUI
import LGSideMenuController
import Firebase

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuItems = [
        [
            "Omer Chart",
            "Settings"
        ],
        [
            "Get the Book",
            "Donate",
            "Tech Support"
        ],
        [
            "What is Omer",
            "Share"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell")!
        cell.textLabel?.text = menuItems[indexPath.section][indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                openNavigator(withIdentifier: "OmerChartNavigator")
            }
            else if indexPath.row == 1 {
                openNavigator(withIdentifier: "SettingsNavigator")
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                if let url = URL(string: Config.URL.bookUrl) {
                    //openWebView(title: "Get the Book", url: url)
                    if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                        Analytics.logEvent("User_Buy_Book", parameters:["Email":"\(userEmail)"])
                    }
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }
            else if indexPath.row == 1 {
                if let url = URL(string: Config.URL.donateUrl) {
                    //openWebView(title: "Donate", url: url)
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }
            else if indexPath.row == 2 {
                if MFMailComposeViewController.canSendMail() {
                    let mailComposerVC = MFMailComposeViewController()
                    mailComposerVC.mailComposeDelegate = self
                    mailComposerVC.setToRecipients(Config.TechSupport.toReceipients)
                    mailComposerVC.setSubject(Config.TechSupport.subject)
                    mailComposerVC.setMessageBody(Config.TechSupport.body, isHTML: false)
                    let mainVC = view.window?.rootViewController as! LGSideMenuController
                    let tabController = mainVC.rootViewController as! UITabBarController
                    tabController.present(mailComposerVC, animated: false, completion: nil)
                    mainVC.hideLeftView()
                }
                else {
                    
                }
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                openNavigator(withIdentifier: "AboutUsNavigator")
            }
            else if indexPath.row == 1 {
                let activityVC = UIActivityViewController(
                    activityItems: [
                        Config.Share.text,Config.ShareView.text
                    ],
                    applicationActivities: nil
                )
                let mainVC = view.window?.rootViewController as! LGSideMenuController
                let tabController = mainVC.rootViewController as! UITabBarController
                tabController.present(activityVC, animated: false, completion: nil)
                mainVC.hideLeftView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: "Footer")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension MenuViewController {
    
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
        let mainVC = view.window?.rootViewController as! LGSideMenuController
        let tabController = mainVC.rootViewController as! UITabBarController
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
        //tabController.present(webNavigator, animated: false, completion: nil)
        mainVC.hideLeftView()
    }
    
    func openNavigator(withIdentifier identifier: String) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        let omerChartNavigator = storyboard?.instantiateViewController(withIdentifier: identifier) as! UINavigationController
        let mainVC = view.window?.rootViewController as! LGSideMenuController
        let tabController = mainVC.rootViewController as! UITabBarController
        tabController.present(omerChartNavigator, animated: false, completion: nil)
        mainVC.hideLeftView()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
