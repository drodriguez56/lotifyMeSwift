//
//  SignupViewController.swift
//  LotifyMe
//
//  Created by Daniel K. Chan on 1/24/15.
//  Copyright (c) 2015 LocoLabs. All rights reserved.
//

    import UIKit
    import CoreData

    class SignupViewController: UIViewController, UITextFieldDelegate {
        
// CAPTURE INPUT FIELDS
        
        @IBOutlet weak var emailInput: UITextField!
        @IBOutlet weak var passwordInput: UITextField!
        
// SUBMIT BUTTON ACTION
        
        @IBAction func signupButton(sender: AnyObject) {
            
            self.view.endEditing(true)

            signupPostRequest(sender)
            
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
        
// SIGNUP POST REQUEST FUNCTION
        
        func signupPostRequest(sender: AnyObject) {
            
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
                "email": emailInput.text,
                "password": passwordInput.text
            ]
            
            var postRequestSuccess = false
            var keepCheckingPostRequestStatus = true
            
            postRequest.POST(
                "http://localhost:4848/users",
                parameters: params,
                success: {
                    (response: HTTPResponse) in
                    println("signupPostRequest() called: Server returned success") // Report
                    if response.responseObject != nil {
                        let resp = Status(JSONDecoder(response.responseObject!))
                        println("Reponse from server has content: \(response.text())") // Report
                        instantiateSession(currentUserEmailOrUsernameAttempt[0])
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
                    println("signupPostRequest() called: User successfully signed up; segue to ProfileViewController") // Report
                    self.performSegueWithIdentifier(
                        "SignupViewControllerSegueToProfileViewController",
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

