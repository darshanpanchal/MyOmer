//
//  BlessingViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/3/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import WebKit

class BlessingViewController: OmerChildBaseViewController {
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var blessing = OmerBlessing()
    var language = OmerLanguage.en
    var weekId = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let languageId = defaults.integer(forKey: "blessing.language")
        if languageId > 0 {
            self.language = OmerLanguage(rawValue: UInt(languageId))!
        }
        
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.navigationDelegate = self
        loadHtml()
    }
    
    @objc override func dayChanged(notification: NSNotification) {
        week = notification.userInfo!["week"]! as? OmerWeek
        day = notification.userInfo!["day"]! as? OmerDay
        weekId = notification.userInfo!["weekId"]! as! Int
        refresh()
    }
    // MARK: - Share Action
    
      @IBAction func callSharing(sender: UIButton){
        
        var blessingString = blessing.blessing.get(language: language) as? String
        if let day = self.day {
            blessingString = blessingString!.replacingOccurrences(of: "%%DYNAMIC1%%", with: day.quote.get(language: language))
            blessingString = blessingString!.replacingOccurrences(of: "%%DYNAMIC2%%", with: day.sefirah.get(language: language))
            if let result = blessingString?.html2String {
                print(result)   // "Björn is great name"
                let activityVC = UIActivityViewController(
                    activityItems: [
                        result,Config.ShareView.text
                    ],
                    applicationActivities: nil
                )
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        
    }
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - WKNavigationDelegate Methods

extension BlessingViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}

// MARK: - LanguageSelectorDelegate Methods

extension BlessingViewController: LanguageSelectorDelegate {
    
    func didSelectLanguage(language: OmerLanguage) {
        self.language = language
        refresh()
    }
}

extension BlessingViewController {
    
    @IBAction func languageButton_Pressed(_ sender: Any) {
        
        let languageVC = storyboard?.instantiateViewController(withIdentifier: "LanguageSelectorViewController") as! LanguageSelectorViewController
        languageVC.language = self.language
        languageVC.delegate = self
        languageVC.modalPresentationStyle = .overCurrentContext
        languageVC.modalTransitionStyle = .crossDissolve
        present(languageVC, animated: true, completion: nil)
    }
    
    @IBAction func recordButton_Pressed(_ sender: Any) {
        if let day = day {
            if recordButton.isSelected {
                let alert = UIAlertController(title: nil, message: "You've already marked the day's blessing as said, do you want to unmark it?", preferredStyle: .actionSheet)
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                    day.markBlessing(false, forYear: Date().currentYear)
                    self.recordButton.isSelected = false
                })
                alert.addAction(yesAction)
                let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
                alert.addAction(noAction)
                present(alert, animated: true, completion: nil)
            }
            else {
                day.markBlessing(true, forYear: Date().currentYear)
                recordButton.isSelected = true
            }
        }
    }
}

extension BlessingViewController {
    
    func refresh() {
        if let week = week, let day = day {
            languageButton.backgroundColor = week.primaryColor
            languageButton.setTitle(language.description, for: .normal)
            recordButton.setImage(UIImage(named: "switch_on_\(weekId)"), for: .selected)
            recordButton.isSelected = day.isBlessingSaid(forYear: Date().currentYear)
            recordLabel.textColor = week.primaryColor
        }
        loadHtml()
    }
    
    func loadHtml() {
        
        var blessingString = blessing.blessing.get(language: language)
        if let day = self.day {
            blessingString = blessingString.replacingOccurrences(of: "%%DYNAMIC1%%", with: day.quote.get(language: language))
            blessingString = blessingString.replacingOccurrences(of: "%%DYNAMIC2%%", with: day.sefirah.get(language: language))
        }
       
        var alignment = "left"
        var direction = ""
        if language == .hb {
            alignment = "right"
            direction = "direction: rtl;"
        }

        let html = "<html><head><meta name='viewport' content='initial-scale=1.0, maximum-scale=10.0'/><body style=\"margin: 2; padding: 2; text-align: \(alignment); \(direction) font: 12pt Gill Sans\">\(blessingString)</body></html>"
       
        UserDefaults.standard.set(html, forKey: "BlessingContent")
        if let webView = webView {
            webView.loadHTMLString(html, baseURL: nil)
        }
        
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
