//
//  Constants.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

let dataBatchSize = 15

enum ErrorMessage {
    static let `default` = "Something went wrong"
}

enum Message {
    static let noResultsFound = "No results found"
    static let noMedicinesInPrescription = "There are no medicines left in this prescription. Please go back to medicines and try adding medicines again."
    static let savePrescription = "Do you want to save this prescription?"
    static let prescriptionSaved = "Prescription saved successfully."
    static let addMedicine = "Please add some medicines."
    static let addDosage = "Please add dosage to your medicine."
}

enum Text {
    static let ok = "Ok"
    static let yes = "Yes"
    static let no = "No"
    static let confirmation = "Confirmation"
    static let done = "Done"
    static let cancel = "Cancle"
    static let edit = "Edit"
}

enum APIUrl {
    static let getMedicines = "https://6082d0095dbd2c001757a8de.mockapi.io/api/medicines"
}

enum UserDefaultKeys {
    static let isFirstLaunch = "isFirstLaunch"
}
