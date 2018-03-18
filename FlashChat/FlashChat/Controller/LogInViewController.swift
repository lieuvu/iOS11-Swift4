//
//  LogInViewController.swift
//  Flash Chat
//


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    // MARK: Outlets
    // **********************************************************************
    
    /// Email text field.
    @IBOutlet var emailTextfield: UITextField!
    
    /// Password text field.
    @IBOutlet var passwordTextfield: UITextField!
    
    // MARK: Actions
    // **********************************************************************
    
    /// Press login button
    ///
    /// - Parameters:
    ///     - sender: The login button.
    @IBAction func logInPressed(_ sender: AnyObject) {
        if
          let email = emailTextfield.text,
          let pwd = passwordTextfield.text
        {
            SVProgressHUD.setMaximumDismissTimeInterval(1.0)
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: email, password: pwd) {
                (user, error) in
                
                guard (error == nil) else {
                    print("Login Error: \(error!)")
                    return
                }
                
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
}  
