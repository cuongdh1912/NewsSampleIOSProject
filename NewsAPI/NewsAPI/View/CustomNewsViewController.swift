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
    lazy var preferencesViewModel: PreferencesViewModel = PreferencesViewModel()
    let preferencesViewMaxHeight:CGFloat = 120.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide pickerview
        preferencesViewHeight?.constant = 0
        // get preference if user registered
        if let preference = UserDefaultManager.shared.getPreference() {
            newsModelView?.updateCurrentPreference(preference: preference)
            newsModelView?.queryToGetNewsFromBeginning(keyword: preference)
            if let index = preferencesViewModel.getIndex(preference: preference) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    // handle refresh control event
    @objc override func handleRefreshControl() {
        super.handleRefreshControl()
        guard let currentPreference = newsModelView?.currentPreference else { return }
        newsModelView?.queryToGetNewsFromBeginning(keyword: currentPreference)        
    }
    // when user click right bar button, show picker view
    @IBAction func filterBarClicked(_ sender: Any) {
        showHidePreferenceView(isVisible: true)
    }
    @IBAction func selectButtonClicked(_ sender: Any) {
        let index = pickerView.selectedRow(inComponent: 0)
        let preference = preferencesViewModel.getPreference(index: index)
        newsModelView?.updateCurrentPreference(preference: preference)
        UserDefaultManager.shared.updatePreference(preference: preference)
        newsModelView?.queryToGetNewsFromBeginning(keyword: preference)
        showHidePreferenceView(isVisible: false)
        // bring the preference for registration
        PreferencesViewModel.selectedPreference = preference
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
}
