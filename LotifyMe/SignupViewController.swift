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
        
        @IBOutlet weak var submitButton: UIButton!

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
            
            let user: Dictionary<String,AnyObject> = [
                "email": emailInput.text,
                "password": passwordInput.text
            ]
            
            let params: Dictionary<String,AnyObject> = [
                "user": user
            ]
            
            currentUserEmailOrUsernameAttempt[0] = emailInput.text
            
            var postRequestStatus = ""
            var keepCheckingPostRequestStatus = true
            
            postRequest.POST(
                "\(rootPath)/users",
                parameters: params,
                success: {
                    (response: HTTPResponse) in
                    println("signupPostRequest() called: Server returned success") // Report
                    if response.responseObject != nil {
                        let resp = Status(JSONDecoder(response.responseObject!))
                        println("Reponse from server has content: \(response.text())") // Report
                        instantiateSession(currentUserEmailOrUsernameAttempt[0])
                        postRequestStatus = "success"
                    } else {
                        println("Uncaught exception: Server returned success without a response (force quit)") // Report
                    }
                },
                failure: {
                    (error: NSError, response: HTTPResponse?) in
                    println("signupPostRequest() called: Server returned failure") // Report
                    postRequestStatus = "failure"
                    if "\(response?.text())" == "Optional(\"signup failed\")" {
                        println("Reason for failure: Invalid signup information") // Report
                        alert(
                            "Try Again",
                            "Check that you entered a valid email, and a password between 6 and 20 characters.",
                            self
                        )
                    } else if "\(response?.text())" == "nil" {
                        println("Reason for failure: Cannot contact server") // Report
                        alert(
                            "No Internet Connection",
                            "Looks like you don't have a connection right now...",
                            self
                        )
                    } else {
                        println("Reason for failure: Uncaught exception") // Report
                        alert(
                            "Oops",
                            "Looks like something went wrong. Please try again!",
                            self
                        )
                    }
                }
            )
                
            while keepCheckingPostRequestStatus == true {
                if postRequestStatus == "success" {
                    keepCheckingPostRequestStatus = false
                    if beforeLoginVariable == "onCreate" {
                        newPickPostRequest(self)
                        resetBeforeLoginVariable()
                        println("Expecting resetBeforeLoginVariable() to have been called") // Report
                    }
                    println("signupPostRequest() called: User successfully signed up; segue to HistoryTableViewController") // Report
                    beforeHistoryVariable = "noBack"
                    self.performSegueWithIdentifier(
                        "SignupViewControllerSegueToHistoryTableViewController",
                        sender: sender
                    )
                } else if postRequestStatus == "failure" {
                    keepCheckingPostRequestStatus = false
                }
            }
            
        }
        
// SETUP
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            self.view.backgroundColor = layerBackgroundColorGlobal
            
            // Layer Styling
            
            self.view.layer.borderColor = layerBorderColorGlobal
            self.view.layer.borderWidth = layerBorderWidth
            
            // Next Button Styling
            
            submitButton.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 18)
            submitButton.setTitleColor(buttonTextColorGlobal, forState: UIControlState.Normal)
            submitButton.backgroundColor = mediumBlue
            submitButton.layer.cornerRadius = buttonCornerRadius
            
            submitButton.layer.borderColor = buttonBorderColorGlobal
            submitButton.layer.borderWidth = buttonBorderWidth
            
            // Nav Bar Styling
            
            self.navigationItem.title = "Signup"
            
            // Input Styling
            
            emailInput.layer.backgroundColor = UIColor.whiteColor().CGColor
            emailInput.layer.cornerRadius = buttonCornerRadius
            
            passwordInput.layer.backgroundColor = UIColor.whiteColor().CGColor
            passwordInput.layer.cornerRadius = buttonCornerRadius
            
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }


    }

