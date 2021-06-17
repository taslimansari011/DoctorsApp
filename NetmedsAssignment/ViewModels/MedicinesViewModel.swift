//
//  MedicinesViewModel.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

final class MedicinesViewModel {
    
    private var medicines = [Medicine]()
    private var searchedMedicines = [Medicine]()
    private let _medicineDataManager = MedicineDataManager(medicineDataStorage: MedicineCoreDataManager())
    var currentBatch = 0
    var selectedMedicines: [Medicine] = []
}

// MARK: - Dosage Picker
extension MedicinesViewModel {
    
    var canProceedToPrescription: Bool {
        get {
            let results = selectedMedicines.filter { medicine in
                medicine.dosage == nil
            }
            return !selectedMedicines.isEmpty && results.isEmpty
        }
    }
}

// MARK: - Helper methods
extension MedicinesViewModel {
    
    /// Count for rows for Medicines Table View
    var numberOfRows: Int {
        return medicines.count
    }
    
    /// Medicine for particular table row
    /// - Parameter indexPath: IndexPath of the table cell
    /// - Returns: Medicine for that table cell
    func getMedicine(for indexPath: IndexPath) -> Medicine {
        return medicines[indexPath.row]
    }
    
    /// Check if we should fetch next batch of medicines from CoreData
    /// - Parameter indexPath: Checking this IndexPath if it is 3rd last row of TableView
    /// - Returns: Returns true if it is 3rd last row of TableView else return false
    func shouldFetchNextBatch(indexPath: IndexPath) -> Bool {
        return indexPath.row == (currentBatch * dataBatchSize) - 3
    }
}

// MARK: - Private methods
extension MedicinesViewModel {
    
    /// Finding the index of a medicine in an array of medicines
    /// - Parameters:
    ///   - medicine: Medicine to find in array
    ///   - medicines: Array of medicines
    /// - Returns: Index of Medicine
    private func index(of medicine: Medicine, in medicines: [Medicine]) -> Int? {
        return medicines.firstIndex { med in
            med.id == medicine.id
        }
    }
    
    /// Updating core data results by matching form already selected medicines
    /// - Parameter results: Medicines from CoreData
    /// - Returns: Updated Medicines
    private func updateResults(results: [Medicine]) -> [Medicine] {
        var newResults = [Medicine]()
        for result in results {
            if let ind = self.index(of: result, in: selectedMedicines) {
                newResults.append(selectedMedicines[ind])
            } else {
                newResults.append(result)
            }
        }
        return newResults
    }
}

// MARK: - Callbacks
extension MedicinesViewModel {
    
    // Called when add or remove button is tapped from any medicine cell...
    func addButtonTapped(indexPath: IndexPath) {
        var medicine = medicines[indexPath.row]
        medicine.isSelected = !medicine.isSelected
        if !medicine.isSelected {
            medicine.dosage = nil
            if let index = index(of: medicine, in: selectedMedicines) {
                selectedMedicines.remove(at: index)
            }
        } else {
            selectedMedicines.append(medicine)
        }
        medicines[indexPath.row] = medicine
    }
    
    // Called when dosage is selected for any medicine ...
    func dosageValueChanged(indexPath: IndexPath, dose: String) {
        var medicine = medicines[indexPath.row]
        medicine.dosage = dose
        if let index = index(of: medicine, in: selectedMedicines) {
            selectedMedicines[index] = medicine
        }
        medicines[indexPath.row] = medicine
    }
}

// MARK: - Medicines Data related methods
extension MedicinesViewModel {
    
    // Getting Medicines Data from API and CoreData
    func getData(searchText: String = "",completion: @escaping () -> Void) {
        if UserDefaults.standard.isFirstLaunch {
            // Get data from API and save into CoreData ...
            fetchAndSaveData {
                UserDefaults.standard.isFirstLaunch = false
                self.getMedicines {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        } else {
            // Get data from CoreData
            getMedicines(searchText: searchText) {
                completion()
            }
        }
    }
    
    // Getting data from CoreData ...
    func getMedicines(searchText: String = "", completion: @escaping () -> Void) {
        _medicineDataManager.getMedicines(searchText: searchText, for: currentBatch) { results in
            let updatedResults = self.updateResults(results: results)
            if !searchText.isEmpty {
                self.medicines = updatedResults
                completion()
            } else {
                if !results.isEmpty {
                    if self.currentBatch == 0 {
                        self.medicines = updatedResults
                    } else {
                        self.medicines.append(contentsOf: updatedResults)
                    }
                    self.currentBatch += 1
                    completion()
                }
            }
        }
    }
}

// MARK: - Initial methods
// Initial fetching of medicines from API and saving medicines to CoreData...
extension MedicinesViewModel {
    // Fetching medicines from API
    func fetchAndSaveData(completion: @escaping () -> Void) {
        let medicineDataManager = MedicineDataManager(medicineDataStorage: MedicineServiceManager())
        medicineDataManager.getMedicines { medicines in
            self.saveData(medicines: medicines)
            completion()
        }
    }
    
    // Save Medicines got from API into CoreData
    func saveData(medicines: [Medicine]) {
        MedicineDataManager(medicineDataStorage: MedicineCoreDataManager()).saveMedicines(medicines: medicines)
    }
}
