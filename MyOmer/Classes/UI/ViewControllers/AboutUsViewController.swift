//
//  AboutViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/18/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "about_us", ofType: "html")!
        let htmlString = try! String(contentsOfFile: path, encoding: .utf8)
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AboutUsViewController {
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}
