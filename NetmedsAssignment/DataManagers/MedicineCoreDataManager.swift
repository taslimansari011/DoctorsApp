//
//  MedicineCoreDataManager.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

final class MedicineCoreDataManager: MedicineDataStorageProtocol {
    
    private let _medicineRepository = MedicineRepository()
    
    func fetchMedicines(searchText: String = "", batch: Int = 0, completion: @escaping ([Medicine]) -> Void) {
        completion(_medicineRepository.getMedicines(searchText: searchText, for: batch) ?? [])
    }
    
    func save(medicines: [Medicine]) {
        _medicineRepository.save(medicines: medicines)
    }
}
