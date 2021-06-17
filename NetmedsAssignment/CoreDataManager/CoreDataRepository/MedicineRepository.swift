//
//  MedicineRepository.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation
import CoreData

final class MedicineRepository: CoreDataRepository {
    
    typealias T = Medicine
    
    func create(model: Medicine) {
        let cdMedicine = CDMedicine(context: PersistentStorage.shared.context)
        if let id = model.id {
            cdMedicine.id = Int64(id)
        }
        cdMedicine.name = model.name
        cdMedicine.type = model.type
        cdMedicine.company = model.company
        cdMedicine.packform = model.packform
        cdMedicine.strength = model.strength
        cdMedicine.strengthtype = model.strengthtype
    }
    
    func get(by id: Int) -> Medicine? {
        return nil
    }
    
    /// Get all medicines
    func getAll() -> [Medicine]? {
        var medicines = [Medicine]()
        let cdMedicines = PersistentStorage.shared.fetchManagedObject(managedObject: CDMedicine.self) ?? []
        for cdMedicine in cdMedicines {
            medicines.append(cdMedicine.convertToMedicine())
        }
        return medicines
    }
    
    /// Get medicines according to batch and search string
    func getMedicines(searchText: String = "", for batch: Int) -> [Medicine]? {
        let batchSize = dataBatchSize
        var medicines = [Medicine]()
        
        let fetchRequest: NSFetchRequest<CDMedicine> = CDMedicine.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if !searchText.isEmpty {
            let predicate = NSPredicate(format: "name contains[c] %@", searchText)
            fetchRequest.predicate = predicate
        } else {
            fetchRequest.fetchOffset = batch * batchSize
            fetchRequest.fetchLimit = batchSize
        }
        
        do {
            let cdMedicines = try PersistentStorage.shared.context.fetch(fetchRequest)
            for cdMedicine in cdMedicines {
                medicines.append(cdMedicine.convertToMedicine())
            }
            return medicines
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func update(model: Medicine) -> Bool {
        // Update core data medicine
        return true
    }
    
    func delete(model: Medicine) -> Bool {
        // Delete core data medicine
        return true
    }
    
    func save(medicines: [Medicine]) {
        for medicine in medicines {
            create(model: medicine)
        }
        PersistentStorage.shared.saveContext()
    }
}
