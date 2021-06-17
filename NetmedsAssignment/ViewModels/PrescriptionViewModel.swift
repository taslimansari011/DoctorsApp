//
//  PrescriptionViewModel.swift
//  NetmedsAssignment
//
//  Created by macadmin on 16/06/21.
//

import Foundation

final class PrescriptionViewModel: NSObject {
    
    @objc dynamic var isEditing = false
    
    var medicines = [Medicine]()
    
    /// Count for rows for Medicines Table View
    var numberOfRows: Int {
        get {
            medicines.count
        }
    }
    
    /// Medicine for particular table row
    /// - Parameter indexPath: IndexPath of the table cell
    /// - Returns: Medicine for that table cell
    func getMedicine(for indexPath: IndexPath) -> Medicine {
        return medicines[indexPath.row]
    }
    
    /// Remove medicine from medicines if it is removed from TableView
    func remove(at indexPath: IndexPath) {
        medicines.remove(at: indexPath.row)
    }
    
    /// Save prescription here
    func savePrescription() {
        medicines = []
    }
}
