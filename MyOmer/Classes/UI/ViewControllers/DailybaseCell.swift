//
//  DailybaseCell.swift
//  MyOmer
//
//  Created by IPS on 23/04/19.
//  Copyright © 2019 Aftab Akhtar. All rights reserved.
//

import UIKit
class EditedUITextView: UITextView {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(cut(_:)) {
            return false
        }
        if action == #selector(paste(_:)) {
            return false
        }
        if action == #selector(select(_:)) {
            return false
        }
        if action == #selector(selectAll(_:)) {
            return false
        }
    
        return false
        //return super.canPerformAction(action, withSender: sender)
    }
    
}
class DailybaseCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var subtitleLbl: UILabel!
    @IBOutlet var meditationLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var shareBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var txtTextView:EditedUITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        // Initialization code
        scrollView.backgroundColor = .clear
        txtTextView.backgroundColor = UIColor.white
        txtTextView.textColor = UIColor.black
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        DispatchQueue.main.async {
           
            self.layoutIfNeeded()
            self.layoutSubviews()
            self.descriptionLbl.layoutIfNeeded()
            self.scrollView.contentSize = CGSize(width:320, height:self.descriptionLbl.frame.height+150.0)
            
        }
    }
}
