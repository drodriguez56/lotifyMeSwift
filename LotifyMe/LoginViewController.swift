//
//  LoginViewController.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/24/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import UIKit
    import CoreData

    class LoginViewController: UIViewController, UITextFieldDelegate {
        
// CAPTURE INPUT FIELDS
        
        @IBOutlet weak var userLoginKeyInput: UITextField!
        @IBOutlet weak var passwordInput: UITextField!
        
// SUBMIT BUTTON ACTION
        
        @IBAction func loginButton(sender: AnyObject) {
            
            self.view.endEditing(true)
            
            loginPostRequest(sender)
            
        }
        
// ENTER KEY ACTION
        
        func textFieldShouldReturn(textField: UITextField) -> Void {
            
            if passwordInput.isFirstResponder() {
                passwordInput.resignFirstResponder()
            } else {
                passwordInput.becomeFirstResponder()
            }
            
        }
        
// TOUCH-UP OUTSIDE ACTION
        
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            
            self.view.endEditing(true)
            
        }
        
// LOGIN POST REQUEST FUNCTION
        
        func loginPostRequest(sender: AnyObject) {
            
            struct Status : JSONJoy {
                var status: String?
                init() {
                    
                }
                init(_ decoder: JSONDecoder) {
                    status = decoder["status"].string
                }
            }
            
            var postRequest = HTTPTask()
            
            let params: Dictionary<String,AnyObject> = [
                "user_input": userLoginKeyInput.text,
                "password": passwordInput.text
            ]
            
            currentUserEmailOrUsernameAttempt[0] = userLoginKeyInput.text
            
            var postRequestSuccess = false
            var keepCheckingPostRequestStatus = true
            
            postRequest.POST(
                "http://localhost:4848/login",
                parameters: params,
                success: {
                    (response: HTTPResponse) in
                    println("loginPostRequest() called: Server returned success") // Report
                    if response.responseObject != nil {
                        let resp = Status(JSONDecoder(response.responseObject!))
                        println("Reponse from server has content: \(response.text())") // Report
                        instantiateSession(currentUserEmailOrUsernameAttempt[0])
                        resetCurrentUserEmailOrUsernameAttempt()
                        println("Expecting resetCurrentUserEmailOrUsernameAttempt() to have been called") // Report
                        if beforeLoginVariable == "onCreate" {
                            postRequestSuccess = true
                        }
                    }
                },
                failure: {
                    (error: NSError, response: HTTPResponse?) in
                    println("signupPostRequest() called: Server returned failure") // Report
                }
            )

            while keepCheckingPostRequestStatus == true {
                if postRequestSuccess == true {
                    keepCheckingPostRequestStatus = false
                    newPickPostRequest(self)
                    resetBeforeLoginVariable()
                    println("Expecting resetBeforeLoginVariable() to have been called") // Report
                    println("loginPostRequest() called: User successfully logged in; segue to ProfileViewController") // Report
                    self.performSegueWithIdentifier(
                        "LoginViewControllerSegueToProfileViewController",
                        sender: sender
                    )
                }
            }
            
        }
        
// SETUP
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = blueBackground
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        
    }

