//
//  LanguageSelectorViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/11/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

protocol LanguageSelectorDelegate {
    func didSelectLanguage(language: OmerLanguage)
}

class LanguageSelectorViewController: UIViewController {
    
    var language: OmerLanguage = .hb
    var delegate: LanguageSelectorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        falsifyLanguageButtons()
        let selectedLanguageButton = view.viewWithTag(Int(language.rawValue)) as! UIButton
        selectedLanguageButton.isSelected = true
    }
    
    // MARK: - Memory Cleanup Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LanguageSelectorViewController {
    
    @IBAction func doneButton_Pressed(_ sender: Any) {
        dismiss(animated: true) {
            if let delegate = self.delegate {
                let defaults = UserDefaults.standard
                defaults.set(Int(self.language.rawValue), forKey: "blessing.language")
                defaults.synchronize()
            
                delegate.didSelectLanguage(language: self.language)
            }
        }
    }
    
    @IBAction func languageButton_Pressed(_ languageButton: UIButton) {
        
        for i in 1...5 {
            let languageButton = view.viewWithTag(i) as! UIButton
            languageButton.isSelected = false
        }
        
        languageButton.isSelected = true
        language = OmerLanguage(rawValue: UInt(languageButton.tag))!
    }
}

extension LanguageSelectorViewController {
    
    func falsifyLanguageButtons() {
        for i in 1...5 {
            let languageButton = view.viewWithTag(i) as! UIButton
            languageButton.isSelected = false
        }
    }
}
