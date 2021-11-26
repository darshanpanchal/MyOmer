//
//  WebViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/18/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - Memory Cleanup Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WebViewController {
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}
