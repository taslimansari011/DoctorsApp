//
//  PrescriptionViewController.swift
//  NetmedsAssignment
//
//  Created by macadmin on 16/06/21.
//

import UIKit

protocol PrescriptionViewControllerDelegate: class {
    func prescriptionSaved()
}

class PrescriptionViewController: UIViewController, StoryBoarded {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIButton!
    
    // MARK: - Variables
    var prescriptionViewModel = PrescriptionViewModel()
    weak var delegate: PrescriptionViewControllerDelegate?
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        registerTableViewCell()
        
        // Adding observer on isEditing
        prescriptionViewModel.addObserver(self, forKeyPath: #keyPath(PrescriptionViewModel.isEditing), options: [.new], context: nil)
    }
    
    deinit {
        // Removing observer from isEditing
        prescriptionViewModel.removeObserver(self, forKeyPath: #keyPath(PrescriptionViewModel.isEditing))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isEditing" {
            updateEditing()
        }
    }
}

// MARK: - Actions
extension PrescriptionViewController {
    @IBAction func actionSave(_ sender: UIButton) {
        showSaveAlert()
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        prescriptionViewModel.isEditing = !prescriptionViewModel.isEditing
    }
}

// MARK: - Helper methods
extension PrescriptionViewController {
    
    private func showSaveAlert() {
        let alert = UIAlertController(title: Text.confirmation, message: Message.savePrescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Text.no, style: .default))
        alert.addAction(UIAlertAction(title: Text.yes, style: .default, handler: { _ in
            self.prescriptionViewModel.savePrescription()
            self.delegate?.prescriptionSaved()
            self.tableView.reloadData()
            self.itemRemoved()
            self.showAlert(message: Message.prescriptionSaved)
        }))
        self.present(alert, animated: true)
    }
    
    private func registerTableViewCell() {
        tableView.register(UINib(nibName: MedicinesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MedicinesTableViewCell.identifier)
    }
    
    private func configureView() {
        tableView.dataSource = self
        tableView.delegate = self
        title = "Prescription"
        saveButton.layer.cornerRadius = saveButton.bounds.height / 2
        saveButton.clipsToBounds = true
        updateEditing()
    }
    
    /// Update UI according to edit mode ...
    private func updateEditing() {
        tableView.setEditing(prescriptionViewModel.isEditing, animated: true)
        editButton.title = prescriptionViewModel.isEditing ? Text.done : Text.edit
    }
    
    /// Do changes to UI after a medicine cell is removed from TableView ...
    private func itemRemoved() {
        /// If table becomes empty
        if prescriptionViewModel.numberOfRows == 0 {
            saveButton.isHidden = true
            prescriptionViewModel.isEditing = false
            editButton.isEnabled = false
            tableView.setNoDataView(message: Message.noMedicinesInPrescription)
        } else {
            tableView.removeNoDataView()
        }
    }
}

// MARK: - UITableViewDataSource
extension PrescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prescriptionViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: MedicinesTableViewCell.identifier, for: indexPath) as? MedicinesTableViewCell {
            cell.configureForPrescriptionTable(medicine: prescriptionViewModel.getMedicine(for: indexPath))
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension PrescriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        /// Delete cell from table and update the table data ...
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            prescriptionViewModel.remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            itemRemoved()
        }
    }
}
