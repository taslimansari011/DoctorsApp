//
//  MedicineServiceManager.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

final class MedicineServiceManager: MedicineDataStorageProtocol {
    
    func fetchMedicines(searchText: String = "", batch: Int, completion: @escaping ([Medicine]) -> Void) {
        guard let url = URL(string: APIUrl.getMedicines) else {
            return
        }
        
        ServiceManager.getRequest(url: url, resultType: [Medicine].self) { result in
            switch result {
            case .success(let medicines):
                completion(medicines)
            
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completion([])
            }
        }
    }
    
    func save(medicines: [Medicine]) {
        
    }
}
