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

            signupPostRequest()
            
        }
    
// ENTER KEY ACTION
        
        func textFieldShouldReturn(textField: UITextField) -> Void {
            
            if passwordInput.isFirstResponder() {
                passwordInput.resignFirstResponder()
                signupPostRequest()
            } else {
                passwordInput.becomeFirstResponder()
            }
            
        }
        
// TOUCH-UP OUTSIDE ACTION
        
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            
            self.view.endEditing(true)
            
        }
        
// SIGNUP POST REQUEST FUNCTION
        
        func signupPostRequest() {
            
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
            
            postRequest.POST(
                "http://localhost:4848/users",
                parameters: params,
                success: {
                    (response: HTTPResponse) in
                    println("signupPostRequest() called: Server returned success") // Report
                    if response.responseObject != nil {
                        let resp = Status(JSONDecoder(response.responseObject!))
                        println("Reponse from server has content: \(response.text())") // Report
                    }
                },
                failure: {
                    (error: NSError, response: HTTPResponse?) in
                    println("signupPostRequest() called: Server returned failure") // Report
                }
            )
            
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

