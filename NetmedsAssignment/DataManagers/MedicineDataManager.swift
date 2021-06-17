//
//  MedicineDataManager.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

/// This class is managing the medicines data for MedicinesViewController ...
final class MedicineDataManager {
    
    /// Dependency Inversion ...
    /// Here I am using MedicineDataStorageProtocol to get and save data.. This protocol can be used for API medicines data and CoreData medicines data as well ...
    /// If in future I need to fetch data from API no changes will be done here.. Just add a class to get data from API and conform it to MedicineDataStorageProtocol ....
    var medicineDataStorage: MedicineDataStorageProtocol
    
    init(medicineDataStorage: MedicineDataStorageProtocol) {
        self.medicineDataStorage = medicineDataStorage
    }
    
    
    /// Get medicines from API or CoreData
    /// - Parameters:
    ///   - searchText: Search medicines according to this text
    ///   - batch: Number of medicines batch
    ///   - completion: Returning the medicines back
    func getMedicines(searchText: String = "", for batch: Int = 0, completion: @escaping ([Medicine]) -> Void) {
        medicineDataStorage.fetchMedicines(searchText: searchText, batch: batch) { medicines in
            completion(medicines)
        }
    }
    
    /// Save the medicines here
    func saveMedicines(medicines: [Medicine]) {
        medicineDataStorage.save(medicines: medicines)
    }
}
