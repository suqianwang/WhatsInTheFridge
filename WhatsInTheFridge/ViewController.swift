//
//  ViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 3/20/21.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    var bg_imageView: UIImageView!
    
    private func background_config() -> UIImageView {
        bg_imageView = UIImageView(frame: view.bounds)
        bg_imageView = UIImageView(image: UIImage(named: "background"))
        bg_imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        bg_imageView.clipsToBounds = true
        bg_imageView.center = view.center
        return bg_imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bg_imageView = background_config()
        view.addSubview(bg_imageView)
        self.view.sendSubviewToBack(bg_imageView)
        view.addSubview(imageView)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.animate()
        })
    }
    
    private func animate() {
        UIView.animate(withDuration: 1.5, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = self.view.frame.size.width - size
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(x: diffX/2, y: diffY/2, width: size, height: size)
        })
        
        UIView.animate(withDuration: 2, animations: {
            self.imageView.alpha = 0
        }, completion: {done in
            if done {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeTabBarControllor = storyboard.instantiateViewController(identifier: "HomtTabBarController")
                homeTabBarControllor.modalTransitionStyle = .crossDissolve
                homeTabBarControllor.modalPresentationStyle = .fullScreen
                self.present(homeTabBarControllor, animated: true)
            }
        })
        
    }

}

