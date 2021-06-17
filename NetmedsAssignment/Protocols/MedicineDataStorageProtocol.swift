//
//  MedicineDataStorageProtocol.swift
//  NetmedsAssignment
//
//  Created by macadmin on 17/06/21.
//

protocol MedicineDataStorageProtocol {
    func fetchMedicines(searchText: String, batch: Int, completion: @escaping ([Medicine]) -> Void)
    func save(medicines: [Medicine])
}
