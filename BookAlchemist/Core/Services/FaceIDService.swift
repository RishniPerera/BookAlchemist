//
//  FaceIDService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.
//

import LocalAuthentication
import Foundation

class FaceIDService {
    static let shared = FaceIDService()
    
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to access your reading library."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authError?.localizedDescription ?? "Authentication failed.")
                    }
                }
            }
        } else {
            completion(false, "Face ID is not available on this device.")
        }
    }
}
