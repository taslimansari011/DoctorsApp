//
//  MedicinesCellViewModel.swift
//  NetmedsAssignment
//
//  Created by macadmin on 17/06/21.
//

import Foundation

final class MedicinesCellViewModel {
    
    private let dosageTitles = ["Once a day", "Twice a day", "Thrice a day", "Once a week", "Twice a week", "Thrice a week"]
}

// MARK: - Dosage Picker
extension MedicinesCellViewModel {
    
    var dosageCount: Int {
        return dosageTitles.count
    }
    
    func dosageTitle(for row: Int) -> String {
        return dosageTitles[row]
    }
}
