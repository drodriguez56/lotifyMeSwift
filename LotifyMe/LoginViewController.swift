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
        
        @IBOutlet weak var submitButton: UIButton!
        
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
            
            var postRequestStatus = ""
            var keepCheckingPostRequestStatus = true
            
            postRequest.POST(
                "\(rootPath)/login",
                parameters: params,
                success: {
                    (response: HTTPResponse) in
                    println("loginPostRequest() called: Server returned success") // Report
                    if response.responseObject != nil {
                        let resp = Status(JSONDecoder(response.responseObject!))
                        println("Reponse from server has content: \(response.text())") // Report
                        var jsonAsString = "\(response.text())" as String
                        instantiateSession(jsonParseEmail(jsonAsString))
                        resetCurrentUserEmailOrUsernameAttempt()
                        println("Expecting resetCurrentUserEmailOrUsernameAttempt() to have been called") // Report
                        postRequestStatus = "success"
                    } else {
                        println("Uncaught exception: Server returned success without a response (force quit)") // Report
                    }
                },
                failure: {
                    (error: NSError, response: HTTPResponse?) in
                    println("loginPostRequest() called: Server returned failure") // Report
                    postRequestStatus = "failure"
                    if "\(response?.text())" == "Optional(\"login failed\")" {
                        println("Reason for failure: Invalid login credentials") // Report
                        alert(
                            "Try Again",
                            "Looks like your email, username, or password might be incorrect.",
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
                    println("loginPostRequest() called: User successfully logged in; segue to HistoryTableViewController") // Report
                    beforeHistoryVariable = "noBack"
                    self.performSegueWithIdentifier(
                        "LoginViewControllerSegueToHistoryTableViewController",
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
            
            self.navigationItem.title = "Login"

            // Input Styling
            
            userLoginKeyInput.layer.backgroundColor = UIColor.whiteColor().CGColor
            userLoginKeyInput.layer.cornerRadius = buttonCornerRadius
            
            passwordInput.layer.backgroundColor = UIColor.whiteColor().CGColor
            passwordInput.layer.cornerRadius = buttonCornerRadius

        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        
    }

