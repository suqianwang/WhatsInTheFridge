//
//  ViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 3/20/21.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {

    // Create an imageView for logo
    private let logo_imageView: UIImageView = {
        let logo_imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        logo_imageView.image = UIImage(named: "logo")
        return logo_imageView
    }()
    
    var bg_imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background to custom
        bg_imageView = Styler.setBackground(bg: "background")
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)
        
        // Add logo
        view.addSubview(logo_imageView)
        
    }

    // After all subviews are layed out, wait 1s to start animation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logo_imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.animate()
        })
    }
    
    // Define animation for the logo
    private func animate() {
        // Logo magnifying for 1.5s
        UIView.animate(withDuration: 1.5, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = self.view.frame.size.width - size
            let diffY = self.view.frame.size.height - size
            self.logo_imageView.frame = CGRect(x: diffX/2, y: diffY/2, width: size, height: size)
        })
        
        // Logo fade out to transparent for 2s
        UIView.animate(withDuration: 2, animations: {
            self.logo_imageView.alpha = 0
        }, completion: {done in
            if done {
                let vcIdentifier = SignupViewController.loadProfile() != nil ? "HomeTabBarController":"Signup"
                // After animation is done, segue to Home Tab Bar Controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: vcIdentifier)
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        })
    }
}

