//
//  Extensions.swift
//  FloatingView
//
//  Created by Meet's Mac on 12/03/24.
//

import UIKit


//MARK: - UIViewController
extension UIViewController{
    
    // show alert message
    func showPopup(message: String){
        self.stopLoader()
        let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let alert = UIAlertController(title: name, message: message, preferredStyle: .alert)
        let ok_action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok_action)
        self.present(alert, animated: true)
    }
    
    // Loader start and stop
    func startLoader(){
        loader.frame = CGRectMake(0, 0, 40, 40)
        loader.style = .medium
        loader.color = .black
        loader.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height / 2)
        self.view.addSubview(loader)
        
        loader.startAnimating()
    }
    
    func stopLoader(){
        loader.stopAnimating()
        loader.removeFromSuperview()
    }
    
    // check orientation
    func isLandscapeMode() -> Bool {
        
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .unknown
        return (orientation == .landscapeRight || orientation == .landscapeLeft) && UIDevice.current.userInterfaceIdiom == .pad
    }
    
}

//MARK: - UIView
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
    }
    
    func conrnerRadius(value: CGFloat = 10) {
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    func border(width: CGFloat = 1) {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = width
    }
}

