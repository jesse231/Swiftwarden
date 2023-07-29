import Foundation
import LocalAuthentication

func authenticate(context: LAContext, completion: @escaping (Bool) -> Void) {
//    let context = LAContext()
    context.localizedFallbackTitle = ""

    var error: NSError?
    let reason = "authenticate to view you're passwords"
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
            if success {
                print("Success")
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                print("Failure")
            }
        }
    } else {
        print("No biometrics")
    }
}
