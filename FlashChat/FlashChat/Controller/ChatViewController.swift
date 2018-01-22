//
//  ViewController.swift
//  Flash Chat
//
//  Created by Lieu Vu.
//

import UIKit
import Firebase
import ChameleonFramework

// MARK: - ChatViewController: UIViewController

class ChatViewController: UIViewController {
    
    // MARK: Outlets
    // **********************************************************************
    
    /// The height constraint of the text field container.
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    
    /// The send button.
    @IBOutlet private var sendButton: UIButton!
    
    /// The message text field.
    @IBOutlet private var messageTextfield: UITextField!
    
    /// The message table view.
    @IBOutlet private var messageTableView: UITableView!
    
    // MARK: Properties
    /********************************************************************/

    /// The keyboard height.
    private var keyboardHeight: CGFloat?
    
    /// The array of messages.
    private var messages: [Message] = []
    
    /// The selected index path.
    private var selectedIndexPath: IndexPath?
    
    // MARK: Override Properties
    // **********************************************************************
    
    // Need to override for the controller become first repsonder
    override var canBecomeFirstResponder: Bool { return true }
    
    // MARK: Life Cycle
    // **********************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the back button in the chat view
        navigationItem.hidesBackButton = true
        
        // Set delegate and datasource of table view
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        // Set delegate of the text field
        messageTextfield.delegate = self
        
        // Register notification center
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: .UIKeyboardWillShow,
            object: nil
        )
        
        // Add tab gesture recognizer to the table view
        let tapTableView = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tapTableView.delaysTouchesBegan = true
        messageTableView.addGestureRecognizer(tapTableView)
        
        // Add long press gesture recognizer to the table view
        let longPressTableView = UILongPressGestureRecognizer(target: self, action: #selector(tableViewLongPressed))
        messageTableView.addGestureRecognizer(longPressTableView)
        
        // Register your MessageCell.xib file here:
//        messageTableView.register(CustomMessageCell.self, forCellReuseIdentifier: "customMessageCell")
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        // Do not use separator in table view
        messageTableView.separatorStyle = .none
        
        // Config table view cell
        configureTableViewCell()
        
        // Retrieve message
        retrieveMessages()
    }
    
    // MARK: Send & Recieve from Firebase
    // **********************************************************************
    
    /// Press send button
    ///
    /// - Parameters:
    ///     - sender: The send button.
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        
        // Disable the message sending triggers
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        if
          let email = Auth.auth().currentUser?.email,
          let messageBody = messageTextfield.text
        {
            let message = ["Sender": email, "MessageBody": messageBody]
            messageDB.childByAutoId().setValue(message) {
                (error, reference) in
                
                guard (error == nil) else {
                    print("\(error!)")
                    return
                }
                
                print("Message saved successfully")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
    }
    
    /// Retrieve messages from the database
    private func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            if
              let messageBody = snapshotValue["MessageBody"],
              let sender = snapshotValue["Sender"]
            {
                self.messages.append( Message(sender: sender, messageBody: messageBody, ref: snapshot.ref.key) )
                self.configureTableViewCell()
                self.messageTableView.reloadData()
            }
        }
    }
    
    // MARK: Actions
    // **********************************************************************
    
    /// Tap table view to resign editign of text field and hide menu controller.
    ///
    /// - Paramters:
    ///     - gestureRecognizer: The tap gesture recognizer.
    @objc private func tableViewTapped(_ gestureRecognizer: UIGestureRecognizer) {
        
        // Resign editing on text field
        if messageTextfield.isFirstResponder {
            messageTextfield.resignFirstResponder()
        }
        
        // Hide menu controller if is shown
        let menuController = UIMenuController.shared
        if menuController.isMenuVisible {
            menuController.isMenuVisible = false
        }
    }
    
    /// Select a cell and pop up menu controller on the table view.
    ///
    /// - Parameters:
    ///     - gestureRecognizer: The long press gesture recognizer.
    @objc private func tableViewLongPressed(_ gestureRecognizer: UIGestureRecognizer) {
        let pressedPos = gestureRecognizer.location(in: messageTableView)
        
        if let indexPath = messageTableView.indexPathForRow(at: pressedPos) {
            becomeFirstResponder()
            selectedIndexPath = indexPath
            
            let selectedCell = messageTableView.cellForRow(at: indexPath) as! CustomMessageCell
            let targetFrame = selectedCell.messageBackground.frame
            let menuController = UIMenuController.shared
            
            menuController.setTargetRect(targetFrame , in: selectedCell)
            menuController.setMenuVisible(true, animated: true)
        }
    }
    
    /// Press logout button
    ///
    /// - Parameters:
    ///     - sender: The logout button.
    @IBAction private func logOutPressed(_ sender: AnyObject) {
        // Log out the user and send them back to the WelcomeViewController
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error, there was a problem signning out.")
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil else {
            print("No View Controllers to pop off")
            return
        }
    }

    // MARK: UIResponder
    // **********************************************************************
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(delete)
    }
    
    override func delete(_ sender: Any?) {
        
        guard let selectedIndexPath = selectedIndexPath else {
            print("Selected Message Index Undefined!")
            return
        }
        
        guard let seletedMessageRef = messages[selectedIndexPath.row].ref else {
            print("Selected Message Reference Undefined!")
            return
        }
        
        let messageRef = Database.database().reference().child("Messages").child(seletedMessageRef)
        messageRef.removeValue {
            (error, messageRef) in
            
            guard (error == nil) else {
                print("\(error!)")
                return
            }
            
            self.messages.remove(at: selectedIndexPath.row)
            self.messageTableView.deleteRows(at: [selectedIndexPath], with: .automatic)
        }
    }
    
}

// MARK: - ChatViewController: UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.senderUsername.text = messages[indexPath.row].sender
        cell.messageBody.text = messages[indexPath.row].messageBody
        cell.avatarImageView.image = UIImage(named: "egg")
        cell.setEditing(true, animated: false)
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
}

// MARK: - ChatViewController: UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - ChatViewController: UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    // **********************************************************************
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let keyboardHeight = keyboardHeight {
            UIView.animate(withDuration: 0.5) {
                self.heightConstraint.constant -= keyboardHeight
                self.keyboardHeight = nil
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show Keyboard
    // **********************************************************************
    
    /// Keyboard will show to calculate the dynamic keyboard height
    ///
    /// - Parameters:
    ///     - notification: The notification to register to.
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyBoardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyBoardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.5) {
                self.heightConstraint.constant += self.keyboardHeight!
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - ChatViewController (Config)

private extension ChatViewController {
    
    /// Config table view cell for row height
    private func configureTableViewCell() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
}

