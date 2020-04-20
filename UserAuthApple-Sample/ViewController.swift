//
//  ViewController.swift
//  UserAuthApple-Sample
//
//  Created by Vladyslav Vcherashnii on 01.02.2020.
//  Copyright © 2020 Vladyslav Vcherashnii. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let signInButton = ASAuthorizationAppleIDButton(type: .default, style: .black)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    // MARK: - Logic
    private func setupController() {
        signInButton.addTarget(self, action: #selector(authorize), for: .touchUpInside)
        self.view.addSubview(signInButton)

        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    }

    @objc
    private func authorize() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func verifyUser() {
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: "Saved user id") { (state, error) in
            switch state {
            case .authorized:
                print("authorized")
            case .notFound:
                print("User not found")
            case .revoked:
                print("Apple has revoked user")
            case .transferred:
                print("Transfered")
            @unknown default:
                break
            }
        }
    }
}

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            let userId = credential.user
            print("User Identifier: ", userId)
            
            if let fullname = credential.fullName {
                print(fullname)
            }
            
            if let email = credential.email {
                print("Email: ", email)
            }
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
}
