import Foundation
import UIKit

extension UIViewController{
    func hideKeyBoard(){
        let touch = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismmisKeyBoard))
        touch.cancelsTouchesInView = true
        view.addGestureRecognizer(touch)
    }
    
    @objc func dismmisKeyBoard(){
        view.endEditing(true)
    }
    
}
