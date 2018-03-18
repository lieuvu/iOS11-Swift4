//
//  RegisterViewController.swift
//  Flash Chat
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    // MARK: Outlets
    // **********************************************************************
    
    /// Email text field.
    @IBOutlet var emailTextfield: UITextField!
    
    /// Password text field.
    @IBOutlet var passwordTextfield: UITextField!
    
    // MARK: Actions
    // **********************************************************************
    
    /// Press register button.
    ///
    /// - Parameters:
    ///     - sender: The register button.
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.setMaximumDismissTimeInterval(1.0)
        SVProgressHUD.show()
        
        // Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            
            guard (error == nil) else {
                print("Register Error: \(error!)")
                return
            }
            
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "goToChat", sender: self)
        }
    }
}
