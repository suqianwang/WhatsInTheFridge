//
//  Styler.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/18/21.
//

import UIKit

class Styler: UIViewController {

    // MARK: - Style background to custom image and fill
    public static func setBackground(bg: String) -> UIImageView {
        let view = self.init().view
        var img: UIImageView!
        img = UIImageView(frame: view!.bounds)
        img = UIImageView(image: UIImage(named: bg))
        img.contentMode =  UIView.ContentMode.scaleAspectFill
        img.clipsToBounds = true
        img.center = view!.center
        return img
    }
    
}
