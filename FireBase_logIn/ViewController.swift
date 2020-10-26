//
//  ViewController.swift
//  FireBase_logIn
//
//  Created by 葉上輔 on 2020/10/9.
//  Copyright © 2020 YehSF. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = " Email Address"
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.autocapitalizationType = .none
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        return emailField
    }()
    
    private let passwordField: UITextField = {
    let passwordField = UITextField()
    passwordField.placeholder = " Password"
    passwordField.layer.borderWidth = 1
    passwordField.isSecureTextEntry = true
    passwordField.layer.borderColor = UIColor.black.cgColor
    passwordField.leftViewMode = .always
    passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
    return passwordField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for: .normal)
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
    }()
    
    @objc private func buttonHandler() {
        print("OK")
        
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("Missing field data")
                
            return
            
        }
        
        // Get auth instance
        // attempt sign in
        // if failure, present alert to creat account
        // if user continues, create account
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] result, error in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                
                strongSelf.showCreateAccount(email: email, password: password)
                
                return
            }
            
            print("you have singed in")
            
            strongSelf.label.isHidden = true
            strongSelf.emailField.isHidden = true
            strongSelf.passwordField.isHidden = true
            strongSelf.button.isHidden = true
            
            strongSelf.emailField.resignFirstResponder()
            strongSelf.passwordField.resignFirstResponder()
            
            if FirebaseAuth.Auth.auth().currentUser != nil {
                
                self?.label.isHidden = true
                self?.emailField.isHidden = true
                self?.passwordField.isHidden = true
                self?.button.isHidden = true
                
                self?.view.addSubview(self!.signOutButton)
                self?.signOutButton.frame = CGRect(x: 20, y: 150, width: self!.view.frame.size.width - 40, height: 52)
                self?.signOutButton.addTarget(self, action: #selector(self?.signOutHandler), for: .touchUpInside)
            }
        })
        
    }
    
    func showCreateAccount(email: String, password: String) {
        
        let alert = UIAlertController(title: "Create Account",
                                      message: "Would you like to create an account",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] result, error in
                
                guard let strongSelf = self else { return }
                           
                guard error == nil else {
                               
                    print("Account creation failed")
                    
                    return
                }
                print("you have singed in")
                
                strongSelf.label.isHidden = true
                strongSelf.emailField.isHidden = true
                strongSelf.passwordField.isHidden = true
                strongSelf.button.isHidden = true
                
                strongSelf.emailField.resignFirstResponder()
                strongSelf.passwordField.resignFirstResponder()
                
                
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
            
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            
            label.isHidden = true
            emailField.isHidden = true
            passwordField.isHidden = true
            button.isHidden = true
            
            view.addSubview(signOutButton)
            signOutButton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 40, height: 52)
            signOutButton.addTarget(self, action: #selector(signOutHandler), for: .touchUpInside)
        }
        
        
        addTapGesture()
    }
    

    
    @objc private func signOutHandler() {
        
        do {
            
            try FirebaseAuth.Auth.auth().signOut()
            
            label.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            button.isHidden = false
            
            signOutButton.removeFromSuperview()
            
        } catch {
            
            print("An error occurred")
            
        }
        
    }
    
    private func addTapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(returnKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func returnKeyboard() {
        
        self.view.endEditing(true)
        
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 150, width: view.frame.size.width, height: 80)
        
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y + label.frame.size.height + 10,
                                  width: view.frame.size.width - 40,
                                  height: 50)
        
        passwordField.frame = CGRect(x: 20,
                                     y: emailField.frame.origin.y + emailField.frame.size.height + 10,
                                     width: view.frame.size.width - 40,
                                     height: 50)
        
        button.frame = CGRect(x: 20,
                              y: passwordField.frame.origin.y + passwordField.frame.size.height + 40,
                              width: view.frame.size.width - 40,
                              height: 60)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            
        emailField.becomeFirstResponder()
            
        }
        
    }

}

