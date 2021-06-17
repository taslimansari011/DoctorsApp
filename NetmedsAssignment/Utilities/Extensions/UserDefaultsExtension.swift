//
//  UserDefaultsExtension.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

extension UserDefaults {
    
    var isFirstLaunch: Bool {
        
        get {
            (UserDefaults.standard.value(forKey: UserDefaultKeys.isFirstLaunch) as? Bool) ?? true
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.isFirstLaunch)
        }
    }
}
