import Foundation
import LocalAuthentication

func authenticate(completion: @escaping (Bool) -> Void) {
    let context = LAContext()
    var error: NSError?
    let reason = "Authenticate to save your data"
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            success, authenticationError in
            if success {
                print("Success")
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                
                print("Failure")
//                completion(false)
            }
        }
    } else {
        print("No biometrics")
    }
}
