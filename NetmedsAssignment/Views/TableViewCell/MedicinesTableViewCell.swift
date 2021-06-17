//
//  MedicinesTableViewCell.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import UIKit

final class MedicinesTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var dosageTextField: UITextField!
    
    private let _medicinesCellViewModel = MedicinesCellViewModel()
    private let picker: MyPickerView = MyPickerView()
    var callbackAdd: (() -> Void)?
    var callbackDosage: ((String) -> Void)?
    
    override func awakeFromNib() {
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        dosageTextField.delegate = self
        dosageTextField.tintColor = .clear
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        typeLabel.text = ""
        companyLabel.text = ""
    }
}

// MARK: - Helper methods
extension MedicinesTableViewCell {
    func configure(medicine: Medicine) {
        
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        addButton.clipsToBounds = true
        
        commonConfiguration(medicine: medicine)
        
        if medicine.isSelected {
            addButton.setImage(UIImage(systemName: "minus"), for: .normal)
            addButton.backgroundColor = .systemRed
        } else {
            addButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addButton.backgroundColor = .orange
        }
        configureDosage()
    }
    
    func configureForPrescriptionTable(medicine: Medicine) {
        addButton.isHidden = true
        commonConfiguration(medicine: medicine)
    }
    
    private func commonConfiguration(medicine: Medicine) {
        titleLabel.text = medicine.name
        typeLabel.text = medicine.type
        if let company = medicine.company {
            companyLabel.text = "By \(company)"
        }
        setDosage(with: medicine)
    }
    
    private func setDosage(with medicine: Medicine) {
        dosageTextField.isHidden = !medicine.isSelected
        dosageTextField.text = medicine.dosage
    }
    
    private func setInitialValues() {
        addButton.isHidden = false
    }
}

// MARK: - Actions
extension MedicinesTableViewCell {
    
    @IBAction func actionAdd(_ sender: UIButton) {
        callbackAdd?()
    }
}

// MARK: - Dosage Picker
extension MedicinesTableViewCell {
    private func configureDosage() {
        dosageTextField.inputView = picker
        dosageTextField.inputAccessoryView = self.picker.toolbar
        
        picker.dataSource = self
        picker.delegate = self
        picker.toolbarDelegate = self
        picker.reloadAllComponents()
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension MedicinesTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _medicinesCellViewModel.dosageCount
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return _medicinesCellViewModel.dosageTitle(for: row)
    }
}

// MARK: - ToolbarPickerViewDelegate
extension MedicinesTableViewCell: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = picker.selectedRow(inComponent: 0)
        picker.selectRow(row, inComponent: 0, animated: false)
        dosageTextField.text = _medicinesCellViewModel.dosageTitle(for: row)
        dosageTextField.resignFirstResponder()
        callbackDosage?(_medicinesCellViewModel.dosageTitle(for: row))
        dosageTextField.isUserInteractionEnabled = true
    }

    func didTapCancel() {
        dosageTextField.resignFirstResponder()
        dosageTextField.isUserInteractionEnabled = true
    }
}

// MARK: - UITextFieldDelegate
extension MedicinesTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count <= 1 {
            return false
        }
        
        return true
    }
}
