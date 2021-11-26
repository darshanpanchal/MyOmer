//
//  DailyViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/3/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit

class DailyViewController: OmerChildBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let calendar = OmerCalendar.getOmerCalendar()
    override func viewDidLoad() {
        super.viewDidLoad()
     
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

extension DailyViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell")!
        
        let dayLabel = cell.contentView.viewWithTag(1) as! UILabel
        dayLabel.text = "DAY \((day?.day)!)"
        
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        titleLabel.text = day?.title
        titleLabel.textColor = week?.secondaryColor
        
        let subtitleLabel = cell.contentView.viewWithTag(3) as! UILabel
        subtitleLabel.text = day?.subtitle
        subtitleLabel.textColor = week?.secondaryColor
        
        let contentLabel = cell.contentView.viewWithTag(4) as! UILabel
        let meditationLabel = cell.contentView.viewWithTag(5) as! UILabel
        
        contentLabel.backgroundColor = UIColor.white
        contentLabel.textColor = UIColor.black
        let shareBtn = cell.contentView.viewWithTag(6) as! UIButton
        shareBtn.addTarget(self, action: #selector(callSharing(sender:)), for: .touchUpInside)
        
        if (day?.content.count)! > 0 {
            meditationLabel.text = "Meditation"
            contentLabel.text = day?.content
        }
        else {
            meditationLabel.text = ""
            contentLabel.text = Config.Meditation.noMeditationText
        }
       
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func callSharing(sender: UIButton){
        let daytitle = "DAY \((day?.day)!)" + "\n"
        let title =  "\((day?.title)!)" + "\n"
        let subtitle = "\((day?.subtitle)!)" + "\n"
        let meditation =   "Meditation:" + "\n"
        let content = day?.content
        
        let activityVC = UIActivityViewController(
            activityItems: [
                daytitle, title, subtitle, meditation, content!,Config.ShareView.text
            ],
            applicationActivities: nil
        )
        self.present(activityVC, animated: true, completion: nil)
        
    }
}

extension DailyViewController  {

    func refresh() {
        if let tableView = tableView {
            tableView.reloadData()
        }
    }
}
