//
//  HomeViewController.swift
//  MyOmer
//
//  Created by Aftab Akhtar on 3/3/18.
//  Copyright © 2018 Aftab Akhtar. All rights reserved.
//

import UIKit
import THSegmentedPager
import WebKit
import Firebase

protocol HomeviewDelegate {
    func indexChanged(index:Int,dayID:Int)
    func dayChangeDelegate(objWeek:OmerWeek)
}
class HomeViewController: THSegmentedPager, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var swipeCollection:UICollectionView!
    @IBOutlet weak var dailyBtn:UIButton!
    @IBOutlet weak var weeklyBtn:UIButton!
    @IBOutlet weak var blessingBtn:UIButton!
    @IBOutlet weak var swipeView:UIView!
    
    
    var weeks = [
        (OmerWeek(week: 1), false),
        (OmerWeek(week: 2), false),
        (OmerWeek(week: 3), false),
        (OmerWeek(week: 4), false),
        (OmerWeek(week: 5), false),
        (OmerWeek(week: 6), false),
        (OmerWeek(week: 7), false)
    ]
    let year = Date().currentYear
//    let calendar = OmerCalendar.getOmerCalendar()
    var dayOfOmer = 0
    
    var week: OmerWeek?
    var weeksId: Int?
    var day: OmerDay?
    var dayId = 1
    var weekId = 1
    var returnID :Int?
    var arrayOfDays:[OmerDay] = []
    var arrauOfWeek:[OmerWeek] = []
    var arrayOfBlessing:[OmerDay] = []
    var tag:Int!
    var blessing = OmerBlessing()
    var language = OmerLanguage.en
    private var indexOfCellBeforeDragging = 0
    private var lastContentOffset: CGFloat = 0
    var totalDaysCount:Int = 0
    fileprivate let calendar = OmerCalendar.getOmerCalendar()
    var isFirstTimeLoad:Bool = false
    var delegate: HomeviewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(self.totalDaysCount)
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged), name: .omerDayChanged, object: nil)
        self.swipeCollection.register(UINib(nibName: "DailybaseCell", bundle: .main), forCellWithReuseIdentifier: "DailybaseCell")
         self.swipeCollection.register(UINib(nibName: "BlessingCell", bundle: .main), forCellWithReuseIdentifier: "BlessingCell")
        self.swipeCollection.delegate = self
        self.swipeCollection.dataSource = self
        self.swipeCollection.isScrollEnabled = false
        
        self.tag = 0

        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.swipeCollection.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.swipeCollection.addGestureRecognizer(swipeLeft)
    }
    override func viewWillAppear(_ animated: Bool) {
        //NotificationCenter.default.addObserver(self, selector: #selector(dayChanged), name: .omerDayChanged, object: nil)
        
    }
    func configureFirstTab(){
        if let _ = self.delegate{
            self.delegate!.indexChanged(index: 0,dayID: self.dayId)
        }
        self.tag = 0
        self.swipeCollection.reloadData()
        self.swipeView.frame = CGRect(x: self.dailyBtn.frame.origin.x, y: self.dailyBtn.frame.height + 2, width: self.dailyBtn.frame.width, height: 4)
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        self.isFirstTimeLoad = true
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                //previous button
                if self.tag == 0{
                    if (self.dayId != 1){
                        let numberOfPlaces = 7.0
                        var totalDays = Double(self.dayId)/numberOfPlaces
                        dayId -= 1
                        totalDays.round(.up)
//                        totalDays += 1.0
                        self.weekId = Int(totalDays)
                        if (dayId) % 7 == 0 && weekId > 1 {
                            weekId -= 1
                        }
                    }else{
                        return
                    }
                   
                    
                }else if self.tag == 1{
                    var totalDay:Int = 0
                    for objWeek in self.weeks{
                        totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
                    }
                    let numberOfPlaces = 7.0
                    var totalDays = Double(self.dayId)/numberOfPlaces
                    totalDays.round(.up)
//                    totalDays += 1.0
                    print(self.dayId)
//                    self.weekId = Int(totalDays)
                    //            numberWeek += 1
                    
                    if let _ = self.weeksId{
                        self.weekId = self.weeksId!
                    }
                    
                    if (self.weekId != 1){
                        weekId -= 1
                    }else{
                        return
                    }
//                    self.nextButton.isEnabled =  self.weekId < numberWeek//self.weekId > 1
//                    self.previousButton.isEnabled = (self.weekId != 1)
                    
                }else if self.tag == 2{
                    if (self.dayId != 1){
                        let numberOfPlaces = 7.0
                        var totalDays = Double(self.dayId)/numberOfPlaces
                        dayId -= 1
                        totalDays.round(.up)
//                        totalDays += 1.0
                        self.weekId = Int(totalDays)
                        if (dayId) % 7 == 0 && weekId > 1 {
                            weekId -= 1
                        }
                    }else{
                        return
                    }
                    
                }else{
                    
                }
       
                week = OmerWeek(week: weekId)
                day = OmerDay(day: dayId)
                
                let nc = NotificationCenter.default
                nc.post(name: .omerDayChanged, object: nil, userInfo: [
                    "weekId": weekId,
                    "week": week!,
                    "dayId": dayId,
                    "day": day!,
                    "tabIndex":self.tag
                    
                    ])
                
                refresh()
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                //next button
                if self.tag == 0{
                    if(dayId == 49 || dayId <= calendar.dayOfOmer){
                        let numberOfPlaces = 7.0
                        var totalDays = Double(self.dayId)/numberOfPlaces
                        totalDays.round(.up)
//                        totalDays += 1.0
                        self.weekId = Int(totalDays)
                        dayId += 1
                        if (dayId - 1) % 7 == 0 {
                            weekId += 1
                        }
                    }else{
                        return
                    }
                    
                }else if self.tag == 1{
                    var totalDay:Int = 0
                    for objWeek in self.weeks{
                        totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
                    }
                    let numberOfPlaces = 7.0
                    var totalDays = Double(totalDay)/numberOfPlaces
                    totalDays.round(.up)
//                    totalDays += 1.0
                    var numberWeek = Int(totalDays)
                    if let _ = self.weeksId{
                        self.weekId = self.weeksId!
                    }
                    if self.weekId < numberWeek{
                        weekId += 1
                    }
//                    self.nextButton.isEnabled =  self.weekId < numberWeek//self.weekId > 1
//                    self.previousButton.isEnabled = (self.weekId != 1)
                    
                }else if self.tag == 2{
                    if(dayId == 49 || dayId <= calendar.dayOfOmer){
                        let numberOfPlaces = 7.0
                        var totalDays = Double(self.dayId)/numberOfPlaces
                        totalDays.round(.up)
//                        totalDays += 1.0
                        self.weekId = Int(totalDays)
                        dayId += 1
                        if (dayId - 1) % 7 == 0 {
                            weekId += 1
                        }
                    }else{
                        return
                    }
                   
                }else{
                    
                }
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
                    "tabIndex":self.tag
                    ])
                
                refresh()
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    @objc func dayChanged(notification: NSNotification) {
     
        self.week = notification.userInfo!["week"]! as? OmerWeek
        self.weeksId = notification.userInfo!["weekId"]! as? Int
        self.day = notification.userInfo!["day"]! as? OmerDay
        if let currentDay = notification.userInfo!["dayId"] as? Int{
            self.dayId = currentDay
        }
        if let objOmerDay = notification.userInfo!["day"]! as? OmerDay{
            var totalDay:Int = 0
            for objWeek in self.weeks{
                totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
            }
            let numberOfDayInWeek = 7.0
            var totalWeek = Double(totalDay) / numberOfDayInWeek
            totalWeek.round(.up)
//            totalWeek += 1.0
            var  numberOfWeeks = Int(totalWeek)
            numberOfWeeks += 1 //increament for loop
            self.arrauOfWeek.removeAll()
            self.arrayOfDays.removeAll()
            self.arrayOfBlessing.removeAll()
            for objWeekID:Int in 1..<Int(numberOfWeeks){
                let objWeek = OmerWeek(week: objWeekID)
                self.arrauOfWeek.append(objWeek)
                for day in objWeek.days(){
                    if day.day <= calendar.dayOfOmer {
                        self.arrayOfDays.append(day)
                        self.arrayOfBlessing.append(day)
                    }
                    
                }
            }
            
        }
        
        self.swipeCollection.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.tag == 0{
                if self.arrayOfDays.count > 0{
                    if self.arrayOfDays.count >= self.dayId,self.dayId > 0{
                        self.swipeCollection.scrollToItem(at: IndexPath.init(item: self.dayId - 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: self.isFirstTimeLoad)
                       
                    }
                }
            }
                if self.tag == 1{
                    if self.arrauOfWeek.count > 0,let _ = self.weeksId{
                        if self.arrauOfWeek.count >= self.weeksId!,self.weeksId! > 0{
                            self.swipeCollection.scrollToItem(at: IndexPath.init(item: self.weeksId! - 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: self.isFirstTimeLoad)
                            
                        }
                    }
            }
            if self.tag == 2{
                if self.arrayOfBlessing.count > 0{
                    if self.arrayOfBlessing.count >= self.dayId,self.dayId > 0{
                        self.swipeCollection.scrollToItem(at: IndexPath.init(item: self.dayId - 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: self.isFirstTimeLoad)
                        
                    }
                }
            }
        }

        refresh()
    }
    //MARK :- Selector Methods
    @IBAction func weeklySelector(sender:UIView){
        print(sender.tag)
    }
    @IBAction func onClickBtn(sender:UIButton){
    
        if sender.tag == 0 {
            self.tag = 0
            self.swipeCollection.reloadData()
            if let _ = self.delegate{
                if self.arrayOfDays.count > 0{
                    if self.arrayOfDays.count >= self.dayId,self.dayId > 0{
                        self.swipeCollection.scrollToItem(at: IndexPath.init(item: self.dayId - 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                    }
                }
               self.delegate!.indexChanged(index: sender.tag,dayID: self.dayId)
            }
            self.swipeView.frame = CGRect(x: self.dailyBtn.frame.origin.x, y: self.dailyBtn.frame.height + 2, width: self.dailyBtn.frame.width, height: 4)
            
        }else if sender.tag == 1{
            self.tag = 1
            self.swipeCollection.reloadData()
            if let _ = self.delegate{
                if self.arrauOfWeek.count > 0,let weekid = self.weeksId{
                    if self.arrauOfWeek.count > weekid,weekid > 0{
                        self.swipeCollection.scrollToItem(at: IndexPath.init(item: weekid - 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                    }
                }
                self.delegate!.indexChanged(index: sender.tag,dayID: self.dayId)
            }
            self.swipeView.frame = CGRect(x: self.weeklyBtn.frame.origin.x, y: self.weeklyBtn.frame.height + 2, width: self.dailyBtn.frame.width, height: 4)
        }else if sender.tag == 2{
            self.tag = 2
            self.swipeCollection.reloadData()

            if let _ = self.delegate{
                if self.arrayOfBlessing.count > 0{
                    if self.arrayOfBlessing.count >= self.dayId,self.dayId > 0{
                        self.swipeCollection.scrollToItem(at: IndexPath.init(item: self.dayId - 1, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                        
                    }
                }
                self.delegate!.indexChanged(index: sender.tag,dayID: self.dayId)
            }
            self.swipeView.frame = CGRect(x: self.blessingBtn.frame.origin.x, y: self.blessingBtn.frame.height + 2, width: self.dailyBtn.frame.width, height: 4)
        }else{
           self.tag = 0
           self.swipeCollection.reloadData()
        }
      
  }
    // MARK: - CollectionView Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0.0,left: 0.0,bottom: 0.0,right: 0.0) // top, left, bottom, right
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.tag == 0{
            return self.arrayOfDays.count
        }else if self.tag == 1{
                return self.arrauOfWeek.count
        }else if self.tag == 2{
            return self.arrayOfBlessing.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

      
        if self.tag == 0 {
        let cell = self.swipeCollection.dequeueReusableCell(withReuseIdentifier: "DailybaseCell", for: indexPath) as! DailybaseCell
        if self.arrayOfDays.count > indexPath.item{
            let objDay = self.arrayOfDays[indexPath.item]
            cell.dayLbl.isHidden = false
            cell.dayLbl.text = "DAY \(objDay.day)"
            cell.titleLbl.text = objDay.title
            if let _ = self.week{
                let objWeek = OmerWeek.init(week: objDay.week)
                if let _ = self.delegate{
                    //self.delegate?.indexChanged(index: 0)
                }
                cell.titleLbl.textColor = objWeek.secondaryColor
                cell.subtitleLbl.textColor = objWeek.secondaryColor
            }
            cell.shareBtn.tag = indexPath.item
            cell.subtitleLbl.text = objDay.subtitle
            cell.shareBtn.addTarget(self, action: #selector(callSharing(sender:)), for: .touchUpInside)
            if (objDay.content.count) > 0 {
                cell.meditationLbl.text = "Meditation"
                cell.descriptionLbl.text = objDay.content
                cell.txtTextView.text = objDay.content
            }else {
                cell.meditationLbl.text = ""
                cell.descriptionLbl.text = Config.Meditation.noMeditationText
                cell.txtTextView.text = Config.Meditation.noMeditationText
            }
        }
            cell.descriptionLbl.layoutIfNeeded()
            cell.scrollView.contentSize = CGSize(width:320, height:cell.descriptionLbl.frame.height+150.0)
            cell.meditationLbl.isHidden = false
//            cell.dayLbl.isHidden = false
            return cell
    }else if self.tag == 1{
              let cell = self.swipeCollection.dequeueReusableCell(withReuseIdentifier: "DailybaseCell", for: indexPath) as! DailybaseCell
            if self.arrauOfWeek.count > indexPath.item{

                let objWeek = self.arrauOfWeek[indexPath.item]
                cell.dayLbl.isHidden = true
                cell.titleLbl.text = objWeek.title

                if let _ = self.week{
                    cell.titleLbl.textColor = self.week!.secondaryColor
                    cell.subtitleLbl.textColor = self.week!.secondaryColor
                }
                cell.shareBtn.tag = indexPath.item
                cell.shareBtn.addTarget(self, action: #selector(callSharing(sender:)), for: .touchUpInside)
                cell.subtitleLbl.text = objWeek.subtitle
                cell.descriptionLbl.attributedText = NSAttributedString(string: (objWeek.content))

                if (objWeek.content.count) > 0 {
                    cell.meditationLbl.text = "Meditation"
                    cell.descriptionLbl.text = objWeek.content
                    cell.txtTextView.text = objWeek.content
                }else {
                    cell.meditationLbl.text = ""
                    cell.descriptionLbl.text = Config.Meditation.noMeditationText
                    cell.txtTextView.text = Config.Meditation.noMeditationText
                }
                cell.meditationLbl.isHidden = true
        }
            //cell.scrollView.contentSize = CGSize(width: cell.descriptionLbl.frame.width, height:cell.descriptionLbl.frame.height)
            return cell
    }else if self.tag == 2{
        let cell = self.swipeCollection.dequeueReusableCell(withReuseIdentifier: "BlessingCell", for: indexPath) as! BlessingCell
         if self.tag == 2{
    
            if self.arrayOfBlessing.count > indexPath.item{
                   let objBlessing  = self.arrayOfBlessing[indexPath.item]
                cell.recordButton.tag = indexPath.item
                cell.languageButton.tag = indexPath.item
                cell.languageButton.backgroundColor = week?.primaryColor
                cell.recordButton.addTarget(self, action: #selector(recordButton_Pressed(sender:)), for: .touchUpInside)
                cell.languageButton.addTarget(self, action: #selector(languageButton_Pressed(sender:)), for: .touchUpInside)
    
                cell.shareButton.addTarget(self, action: #selector(callSharing(sender:)), for: .touchUpInside)
                cell.webView.scrollView.showsHorizontalScrollIndicator = false
                cell.webView.scrollView.showsVerticalScrollIndicator = false
                cell.webView.navigationDelegate = self as WKNavigationDelegate
                cell.recordLabel.textColor = week?.primaryColor
                
                cell.recordButton.tag = indexPath.item
                cell.languageButton.tag = indexPath.item
                cell.shareButton.tag = indexPath.item
                cell.shareButton.addTarget(self, action: #selector(callSharing(sender:)), for: .touchUpInside)
                var weekID = indexPath.item / 7 + 1
                if weekID > 7 {
                    weekID = 7
                }
                cell.recordButton.isSelected = day!.isBlessingSaid(forYear: Date().currentYear)
                if day!.isBlessingSaid(forYear: Date().currentYear){
                    cell.recordButton.setImage(UIImage(named: "switch_on_\(weekID)"), for: .selected)
                }else{
                    cell.recordButton.setImage(UIImage(named: "switch_off"), for: .normal)
                }
                let defaults = UserDefaults.standard
                let languageId = defaults.integer(forKey: "blessing.language")
                if languageId > 0 {
                    self.language = OmerLanguage(rawValue: UInt(languageId))!
                    cell.languageButton.setTitle(language.description, for: .normal)
                }else{
                    
                }
                var blessingString = blessing.blessing.get(language: language)
                //if let day = objBlessing {
                    blessingString = blessingString.replacingOccurrences(of: "%%DYNAMIC1%%", with: objBlessing.quote.get(language: language))
                    blessingString = blessingString.replacingOccurrences(of: "%%DYNAMIC2%%", with: objBlessing.sefirah.get(language: language))
                //}
                print(blessingString)
                var alignment = "left"
                var direction = ""
                if language == .hb {
                    alignment = "right"
                    direction = "direction: rtl;"
                }
                
                let html = "<html><head><meta name='viewport' content='initial-scale=1.0, maximum-scale=10.0'/><body style=\"margin: 2; padding: 2; text-align: \(alignment); \(direction) font: 12pt Gill Sans\">\(blessingString)</body></html>"
                
                UserDefaults.standard.set(html, forKey: "BlessingContent")
                if let webView = cell.webView {
                    cell.webView.loadHTMLString(html, baseURL: nil)
                }
        }
            }
            return cell
        }else{
            
            return UICollectionViewCell()
        }
    

    }
     @objc func recordButton_Pressed(sender: UIButton){
        let button = sender as UIButton
        let indexPath = NSIndexPath(item: button.tag, section: 0)//NSIndexPath(forRow:button.tag inSection:0)
        if let cells = swipeCollection.cellForItem(at: indexPath as IndexPath) as? BlessingCell{
            if let days = day {
                if cells.recordButton.isSelected {
                    let alert = UIAlertController(title: nil, message: "You've already marked the day's blessing as said, do you want to unmark it?", preferredStyle: .actionSheet)
                    let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                        days.markBlessing(false, forYear: Date().currentYear)
                        cells.recordButton.isSelected = false
                    })
                    alert.addAction(yesAction)
                    let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
                    alert.addAction(noAction)
                    present(alert, animated: true, completion: nil)
                }
                else {
                    days.markBlessing(true, forYear: Date().currentYear)
                    cells.recordButton.isSelected = true
                }
                var weekID = sender.tag / 7 + 1
                if weekID > 7 {
                    weekID = 7
                }
                if days.isBlessingSaid(forYear: Date().currentYear){
                    cells.recordButton.setImage(UIImage(named: "switch_on_\(weekID)"), for: .selected)
                }else{
                    cells.recordButton.setImage(UIImage(named: "switch_off"), for: .normal)
                }
                cells.recordButton.isSelected = days.isBlessingSaid(forYear: Date().currentYear)
                cells.recordLabel.textColor = week?.primaryColor
            }
    }
}
    @objc func languageButton_Pressed(sender: UIButton){
        let languageVC = storyboard?.instantiateViewController(withIdentifier: "LanguageSelectorViewController") as! LanguageSelectorViewController
        languageVC.language = self.language
        languageVC.delegate = self as LanguageSelectorDelegate
        languageVC.modalPresentationStyle = .overCurrentContext
        languageVC.modalTransitionStyle = .crossDissolve
        present(languageVC, animated: true, completion: nil)
        
    }
    @objc func callSharing(sender: UIButton){
        
        if self.tag == 0{
            if let content = day?.content{
    
                let daytitle = "DAY \((day?.day)!)" + "\n" + "\((day?.title)!)" + "\n" + "\((day?.subtitle)!)" + "\n" + "Meditation:" + "\n" + "\(content)" + "\n" + "\(Config.ShareView.text)"
                //            let title =  "\((day?.title)!)" + "\n"
                //            let subtitle = "\((day?.subtitle)!)" + "\n"
                //            let meditation =   "Meditation:" + "\n"
                //            let content = day?.content
                
                let activityVC = UIActivityViewController(
                    activityItems: [
                        daytitle//, title, subtitle, meditation, content!,Config.ShareView.text
                    ],
                    applicationActivities: nil
                )
                if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                    Analytics.logEvent("User_Share_Daily", parameters:["Email":"\(userEmail)"])
                }
                self.present(activityVC, animated: true, completion: nil)
            }
        }else if self.tag == 1{
            if let titleWeek = week?.subtitle , let weekContent = week?.content {
                
                let title = "\((week?.title)!)" + "\n" + "\(titleWeek)" + "\(weekContent)" +  "\n" + "\(Config.ShareView.text)"
                //            let subtitle = week?.subtitle
                //            let content = week?.content
                
                let activityVC = UIActivityViewController(
                    activityItems: [
                        title//, subtitle!, content!,Config.ShareView.text
                    ],
                    applicationActivities: nil
                )
                if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                    Analytics.logEvent("User_Share_Weekly", parameters:["Email":"\(userEmail)"])
                }
                self.present(activityVC, animated: true, completion: nil)
            }
        }else{
            var blessingString = blessing.blessing.get(language: language) as? String
            if let day = self.day {
                blessingString = blessingString!.replacingOccurrences(of: "%%DYNAMIC1%%", with: day.quote.get(language: language))
                blessingString = blessingString!.replacingOccurrences(of: "%%DYNAMIC2%%", with: day.sefirah.get(language: language))
                if let result = blessingString?.html2String {
                    let passStr = "\(result)" + "\n" + "\(Config.ShareView.text)"
                    let activityVC = UIActivityViewController(
                        activityItems: [
                            passStr
                        ],
                        applicationActivities: nil
                    )
                    if let userEmail = UserDefaults.standard.value(forKey: "RegisterEmailKey"){
                        Analytics.logEvent("User_Share_Blessings", parameters:["Email":"\(userEmail)"])
                    }
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
            
        }
      
        
    }
    // MARK: - Memory Cleanup Methods
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController {
    
    func refresh() {
        customizePageControl()
        colorifyPreviousWeeks()
   
    }
    
    func customizePageControl() {
        
        self.pageControl.backgroundColor = UIColor.clear
        self.pageControl.selectionIndicatorColor = UIColor.white
        self.pageControl.isVerticalDividerEnabled = false
        self.pageControl.isHidden = true
        self.pageControl.selectionStyle = .textWidthStripe
        self.pageControl.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16.0)!,
            NSAttributedString.Key.foregroundColor: (week?.secondaryColor)!
        ]
        self.pageControl.selectedTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16.0)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        print(self.pageControl.selectedSegmentIndex)
        self.setSelectedPageIndex(UInt(self.pageControl.selectedSegmentIndex), animated: true)
    }
    
    func colorifyPreviousWeeks() {
        var totalDay:Int = 0
        for objWeek in self.weeks{
            totalDay += objWeek.0.days().filter{$0.day <= calendar.dayOfOmer}.count
        }
        let numberOfPlaces = 7.0
        var totalDays = Double(totalDay)/numberOfPlaces
        totalDays.round(.up)
//        totalDays += 1.0
        for id in 1...Int(totalDays){
            print("====== \(id)")
            let w = OmerWeek(week: id)
            let lblWeek = view.viewWithTag(100+id) as! UILabel
            lblWeek.backgroundColor = w.primaryColor
            lblWeek.textColor = UIColor.white
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapDetected))
            lblWeek.addGestureRecognizer(singleTap)
        }
        
        //        if weeksId! < 7 {
        //            for id in weeksId!+1...7 {
        //                let lblWeek = view.viewWithTag(100+id) as! UILabel
        //                lblWeek.backgroundColor = UIColor(hexString: "e9e9e9")
        //                lblWeek.textColor = UIColor(hexString: "c1c1c1")
        //            }
        //        }
    }
    @objc func tapDetected(_ sender: UITapGestureRecognizer){
        if let _ = sender.view{
            var objtag = sender.view!.tag - 100
            self.tag = 1
            self.swipeView.frame = CGRect(x: self.weeklyBtn.frame.origin.x, y: self.weeklyBtn.frame.height + 2, width: self.dailyBtn.frame.width, height: 4)
            self.weekId = objtag
            if objtag == 1{
                self.dayId = 1
            }else{
                objtag -= 1
                self.dayId = (objtag * 7) + 1
            }
            
            guard self.dayId < 50 else{
                return
            }
            guard self.weekId < 8 else{
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
                "tabIndex":1
                ])
            
            refresh()
        }
    }
}
// MARK: - WKNavigationDelegate Methods
extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}
extension HomeViewController: LanguageSelectorDelegate {
    
    func didSelectLanguage(language: OmerLanguage) {
        self.language = language
        self.swipeCollection.reloadData()
    }
}
