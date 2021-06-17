//
//  UITableViewExtension.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import UIKit

// MARK: - UITableView
extension UITableView {
    
    func setNoDataView(message: String? = nil) {
        
        removeNoDataView()
        
        isScrollEnabled = false
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: self.bounds.size.height))
        noDataLabel.numberOfLines = 0
        if let message1 = message {
            noDataLabel.text = message1
        } else {
            noDataLabel.text = "No data available"
        }
        noDataLabel.textColor = .label
        
        noDataLabel.textAlignment = .center
        noDataLabel.tag = 999
        backgroundView = noDataLabel
    }
    
    func removeNoDataView() {
        isScrollEnabled = true
        for view in self.subviews where view.tag == 999 {
            view.removeFromSuperview()
        }
        backgroundView = nil
    }
}


