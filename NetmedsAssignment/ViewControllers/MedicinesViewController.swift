//
//  ViewController.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import UIKit

class MedicinesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Variables
    lazy var searchBar: UISearchBar = UISearchBar()
    private let _medicinesViewModel = MedicinesViewModel()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableViewCell()
        configureView()
        getData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Actions
extension MedicinesViewController {
    
    @IBAction func actionPrescroption(_ sender: UIBarButtonItem) {
        if _medicinesViewModel.canProceedToPrescription {
            let controller = PrescriptionViewController.instantiaite(storyboard: .main)
            controller.delegate = self
            let viewModel = PrescriptionViewModel()
            viewModel.medicines = _medicinesViewModel.selectedMedicines.sorted{ $0.name ?? "" < $1.name ?? "" }
            controller.prescriptionViewModel = viewModel
            navigationController?.pushViewController(controller, animated: true)
        } else {
            if _medicinesViewModel.selectedMedicines.isEmpty {
                showAlert(message: Message.addMedicine)
            } else {
                showAlert(message: Message.addDosage)
            }
        }
    }
}

// MARK: - Helper methods
extension MedicinesViewController {
    
    private func registerTableViewCell() {
        tableView.register(UINib(nibName: MedicinesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MedicinesTableViewCell.identifier)
    }
    
    private func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Medicines"
        navigationController?.navigationBar.tintColor = .systemOrange
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "Search Medicine"
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
    }
    
    private func getData(searchText: String = "") {
        showLoader()
        _medicinesViewModel.getData(searchText: searchText) { [weak self] in
            guard let self = self else { return }
            self.hideLoader()
            self.tableView.reloadData()
            if self._medicinesViewModel.numberOfRows == 0 {
                self.tableView.setNoDataView(message: Message.noResultsFound)
            } else {
                self.tableView.removeNoDataView()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MedicinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _medicinesViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: MedicinesTableViewCell.identifier, for: indexPath) as? MedicinesTableViewCell {
            cell.configure(medicine: _medicinesViewModel.getMedicine(for: indexPath))
            
            cell.callbackAdd = {
                self._medicinesViewModel.addButtonTapped(indexPath: indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            cell.callbackDosage = { dose in
                self._medicinesViewModel.dosageValueChanged(indexPath: indexPath, dose: dose)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension MedicinesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if _medicinesViewModel.shouldFetchNextBatch(indexPath: indexPath) {
                getData()
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension MedicinesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            _medicinesViewModel.currentBatch = 0
        }
        getData(searchText: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - PrescriptionViewControllerDelegate
extension MedicinesViewController: PrescriptionViewControllerDelegate {
    func prescriptionSaved() {
        _medicinesViewModel.currentBatch = 0
        _medicinesViewModel.selectedMedicines = []
        _medicinesViewModel.getData {
            self.tableView.reloadData()
        }
    }
}
