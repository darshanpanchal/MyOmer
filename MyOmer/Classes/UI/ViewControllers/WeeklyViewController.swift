//
//  WeeklyViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/3/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import FRHyperLabel

class WeeklyViewController: OmerChildBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    @objc override func dayChanged(notification: NSNotification) {
        
        week = notification.userInfo!["week"]! as? OmerWeek
        day = notification.userInfo!["day"]! as? OmerDay
    
        refresh()
    }
    
    // MARK: - Memory Cleanup Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension WeeklyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyCell")!
        
        let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
        titleLabel.text = week?.title
        titleLabel.textColor = week?.secondaryColor
        
        let subtitleLabel = cell.contentView.viewWithTag(2) as! UILabel
        subtitleLabel.text = week?.subtitle
        subtitleLabel.textColor = week?.secondaryColor
        
        let contentLabel = cell.contentView.viewWithTag(3) as! FRHyperLabel
        contentLabel.attributedText = NSAttributedString(string: (week?.content)!)
        contentLabel.setLinkForSubstring((week?.youtubeVideoUrl)!) { (label, linkString) in
            let url = URL(string: linkString!)!
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
        
        let shareBtn = cell.contentView.viewWithTag(4) as! UIButton
        shareBtn.addTarget(self, action: #selector(callSharing(sender:)), for: .touchUpInside)
      
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: (week?.youtubeVideoUrl)!)!
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func callSharing(sender: UIButton){
       // "\((week?.title)!)" + "\n"
        let title = "\((week?.title)!)" + "\n"
        let subtitle = week?.subtitle
        let content = week?.content
        
        let activityVC = UIActivityViewController(
            activityItems: [
                 title, subtitle!, content!,Config.ShareView.text
            ],
            applicationActivities: nil
        )
        self.present(activityVC, animated: true, completion: nil)
        
    }
}

extension WeeklyViewController {
    
    func refresh() {
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
