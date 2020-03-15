//
//  CustomNewsViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit

class CustomNewsViewController: NewsViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var preferencesViewHeight: NSLayoutConstraint? // = 0 => hide pickerview
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    var customNewsViewModel: CustomNewsViewModel? // ViewModel
    lazy var preferencesViewModel: PreferencesViewModel = PreferencesViewModel()
    let preferencesViewMaxHeight:CGFloat = 120.0
    var currentPreference: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide pickerview
        preferencesViewHeight?.constant = 0
        customNewsViewModel = CustomNewsViewModel(delegate: self)
        newsModelView = customNewsViewModel
        // get preference if user registered
        if let preference = UserDefaultManager.shared.getPreference() {
            currentPreference = preference
            customNewsViewModel?.queryToGetCustomNews(keyword: currentPreference)
            if let index = preferencesViewModel.getIndex(preference: preference) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    // handle refresh control event
    @objc override func handleRefreshControl() {
        guard let currentPreference = currentPreference else { return }
        customNewsViewModel?.queryToGetCustomNews(keyword: currentPreference)
        // Dismiss the refresh control.
        DispatchQueue.main.async {[unowned self] in
            self.tableView?.refreshControl?.endRefreshing()
        }
    }
    // when user click right bar button, show picker view
    @IBAction func filterBarClicked(_ sender: Any) {
        showHidePreferenceView(isVisible: true)
    }
    @IBAction func selectButtonClicked(_ sender: Any) {
        let index = pickerView.selectedRow(inComponent: 0)
        currentPreference = preferencesViewModel.getPreference(index: index)
        UserDefaultManager.shared.updatePreference(preference: currentPreference)
        customNewsViewModel?.queryToGetCustomNews(keyword: currentPreference)
        showHidePreferenceView(isVisible: false)
        // bring the preference for registration
        PreferencesViewModel.selectedPreference = currentPreference
    }
    // hide preferencesView
    @IBAction func cencelButtonClicked(_ sender: Any) {
        showHidePreferenceView(isVisible: false)
    }
    func showHidePreferenceView(isVisible: Bool) {
        if isVisible {
            navigationItem.rightBarButtonItem?.isEnabled = false
            preferencesViewHeight?.constant = preferencesViewMaxHeight
        }else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            preferencesViewHeight?.constant = 0
        }
    }
    override func newsAPIRequestSuccess() {
        super.newsAPIRequestSuccess()
        // show table view when we recieve data for the first time
        if let tableView = tableView, tableView.isHidden {
            tableView.isHidden = false
        }
    }
}
// MARK: -- PickerView implementation
extension CustomNewsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1 // the amount of "columns" in the picker view
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return preferencesViewModel.getTotalPreferences() // the amount of elements (row)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return preferencesViewModel.getPreference(index: row) // the actual string to display for the row "row"
    }
    // called when user select a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
