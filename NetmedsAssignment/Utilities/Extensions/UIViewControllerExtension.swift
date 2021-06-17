//
//  UIViewControllerExtension.swift
//  NetmedsAssignment
//
//  Created by macadmin on 16/06/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(with title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Text.ok, style: .default))
        self.present(alert, animated: true)
    }
    
    func showLoader() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func hideLoader() {
        for view in view.subviews where view is UIActivityIndicatorView {
            view.removeFromSuperview()
        }
    }
}
