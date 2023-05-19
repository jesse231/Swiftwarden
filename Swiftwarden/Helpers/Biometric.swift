import Foundation
import LocalAuthentication

func authenticate(completion: @escaping (Bool) -> Void) {
    let context = LAContext()
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
//                completion(false)
            }
        }
    } else {
        print("No biometrics")
    }
}
