//
//  BlessingCell.swift
//  MyOmer
//
//  Created by IPS on 27/03/19.
//  Copyright © 2019 Aftab Akhtar. All rights reserved.
//

import UIKit
import WebKit
class BlessingCell: UICollectionViewCell {
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.layoutSubviews()
        }
    }
}
