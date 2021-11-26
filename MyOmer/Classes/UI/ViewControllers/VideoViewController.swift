//
//  VideoViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/7/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import WebKit

class VideoViewController: OmerChildBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var dayId:Int = 1
    var weekId:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.tableView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.tableView.addGestureRecognizer(swipeLeft)
    }
    
    @objc override func dayChanged(notification: NSNotification) {
        week = notification.userInfo!["week"]! as? OmerWeek
        day = notification.userInfo!["day"]! as? OmerDay
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
          self.tableView.setContentOffset(.zero, animated: false)
        }
        if let _ = self.week,let _ = day{
            self.weekId = self.week!.id
            self.dayId = self.day!.day
        }
    }
    
    // MARK: - Memory Cleanup Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer){
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                //PREVIOUS SELECTOR
                if (self.dayId != 1){
                    let numberOfPlaces = 7.0
                    var totalDays = Double(self.dayId)/numberOfPlaces
                    dayId -= 1
                    totalDays.round(.up)
                    self.weekId = Int(totalDays)
                    if (dayId) % 7 == 0 && weekId > 1 {
                        weekId -= 1
                    }
                    self.postDayChangeNotificationRequest()
                }else{
                    return
                }
                
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                //NEXT SELECTOR
                if(dayId == 49 || dayId <= OmerCalendar.getOmerCalendar().dayOfOmer){
                    let numberOfPlaces = 7.0
                    var totalDays = Double(self.dayId)/numberOfPlaces
                    totalDays.round(.up)
                    self.weekId = Int(totalDays)
                    dayId += 1
                    if (dayId - 1) % 7 == 0 {
                        weekId += 1
                    }
                    self.postDayChangeNotificationRequest()
                }else{
                    return
                }
                 print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    func postDayChangeNotificationRequest() {
        guard dayId < 50 else{
            return
        }
        guard weekId < 8 else{
            return
        }
        week = OmerWeek(week: weekId)
        
        day = OmerDay(day: dayId)
        
        let nc = NotificationCenter.default
        nc.post(name: .omerDayChanged, object: nil, userInfo: [
            "weekId": weekId,
            "week": week!,
            "dayId": dayId,
            "day": day!,
            "tabIndex":0
            ])
    }
}

extension VideoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell")!
        
        let quoteLabel = cell.contentView.viewWithTag(1) as! UILabel
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        let descLabel = cell.contentView.viewWithTag(4) as! UILabel
        let thumbnailImageView = cell.contentView.viewWithTag(3) as! UIImageView
        
        if let week = week, let day = day {
            let shareBtn = cell.contentView.viewWithTag(5) as! UIButton

            if let video = day.video {
                quoteLabel.text = day.title
                quoteLabel.textColor = week.primaryColor
                titleLabel.textAlignment = .left
                titleLabel.text = video.title
                descLabel.text = video.desc
                thumbnailImageView.image = UIImage(named: "\(day.day)")
                shareBtn.isHidden = false
            }else{
                quoteLabel.text = ""
                titleLabel.textAlignment = .center
                titleLabel.text = Config.Video.noVideoText
                descLabel.text = ""
                thumbnailImageView.image = nil
                shareBtn.isHidden = true
            }
            shareBtn.addTarget(self, action: #selector(callSharing(sender:)), for: .touchUpInside)
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
        if let video = day?.video {
            let daytitle = "\((day?.title)!)" + "\n" + "\((video.title))" + "\n" + "\((video.desc))" + "\n" + "\(video.youtubeVideoUrl)" + "\n" + "\(Config.ShareView.text)"
//            let title =  "\((video.title))" + "\n"
//            let subtitle = "\((video.desc))" + "\n"
//            let url = video.youtubeVideoUrl
        print(daytitle)
           
            let activityVC = UIActivityViewController(
                activityItems: [
                    daytitle
                ],
                applicationActivities: nil
            )
            self.present(activityVC, animated: true, completion: nil)
        }
        
        
    }
}

extension VideoViewController {
    
    @IBAction func playButton_Pressed(_sender: Any) {
        
        if let day = day {
            if let video = day.video {
                UIApplication.shared.open(video.youtubeVideoUrl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
