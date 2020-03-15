//
//  ProfileViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import UIKit

struct SubmitText{
    static let register = "Register"
    static let signout = "Sign Out"
}
class ProfileViewController: UIViewController {
    @IBOutlet weak var inputTitleLabel: UILabel?
    @IBOutlet weak var userNameTextField: UITextField?
    @IBOutlet weak var nameTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var addressTextField: UITextField?
    @IBOutlet weak var submitButton: UIButton?
    @IBOutlet weak var passwordView: UIStackView?
    var registered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load profile
        if let profile = UserDefaultManager.shared.getProfile() {
            userNameTextField?.text = profile.userName
            nameTextField?.text = profile.name
            addressTextField?.text = profile.address
            showHideRegisterFields(isVisible: false)
            registered = true
        }
    }
    func showHideRegisterFields(isVisible: Bool) {
        inputTitleLabel?.isHidden = !isVisible
        passwordView?.isHidden = !isVisible
        let submitText = isVisible ? SubmitText.register:SubmitText.signout
        submitButton?.setTitle(submitText, for: .normal)
        userNameTextField?.isEnabled = isVisible
        nameTextField?.isEnabled = isVisible
        passwordTextField?.isEnabled = isVisible
        addressTextField?.isEnabled = isVisible
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if registered { // sign out
            userNameTextField?.text = ""
            nameTextField?.text = ""
            addressTextField?.text = ""
            passwordTextField?.text = ""
            UserDefaultManager.shared.removeProfile()
            PreferencesViewModel.selectedPreference = nil
        }else { // sign in
            if !checkValidation() {
                return
            }
            let profile = Profile()
            profile.userName = userNameTextField?.text?.trimmingCharacters(in: .whitespaces)
            profile.name = nameTextField?.text
            profile.address = addressTextField?.text
            profile.preference = PreferencesViewModel.selectedPreference
            UserDefaultManager.shared.saveProfile(profile: profile)
        }
        registered = !registered
        showHideRegisterFields(isVisible: !registered)
    }
    @IBAction func backgroundButtonClicked(_ sender: Any) {
        // hide keyboard
        self.view.endEditing(true)
    }
    func isEmpty(text: String?) -> Bool{
        if let userName = text {
            let string = userName.trimmingCharacters(in: .whitespaces)
            return string.count == 0
        }else {
            return true
        }
    }
    func checkValidation() -> Bool {
        if isEmpty(text: userNameTextField?.text) {
            // show error alert
            RouteManager.showAlert(message: AlertText.userNameEmpty, parrent: self)
            return false
        }
        
        if isEmpty(text: passwordTextField?.text) {
            // show error alert
            RouteManager.showAlert(message: AlertText.passwordEmpty, parrent: self)
            return false
        }
        return true
    }
}
