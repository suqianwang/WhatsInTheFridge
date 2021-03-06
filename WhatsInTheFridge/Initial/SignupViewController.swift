//
//  ProfileSetupViewController.swift
//  WhatsInTheFridge
//
//  Created by Suqian Wang on 4/19/21.
//

import UIKit
import OSLog

class SignupViewController: UIViewController, UITextFieldDelegate {

    var profile:ProfileData?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var button: UIButton!
    
    // When button is pressed, save user entry to data
    @IBAction func button_action(_ sender: Any) {
        let text = name.text
        if text != nil && text != "" {
            profile = ProfileData(username: text!)
            saveProfile()
            // go to home
            os_log(.info, "profile data saved into archive")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HomeTabBarController")
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }else{
            os_log(.info, "profile data not saved into archive")
        }
        

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty{
            button?.isUserInteractionEnabled = true
            button?.alpha = 1.0
        } else {
            button?.isUserInteractionEnabled = false
            button?.alpha = 0.5
        }
        return true
    }
    
    let placeHolderText:String = "enter name here"
    var bg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bg = Styler.setBackground(bg: "signup")
        view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
        name.placeholder = placeHolderText
        name?.delegate = self
        button?.isUserInteractionEnabled = false
        button?.alpha = 0.5
        button.layer.cornerRadius = 10
        
    }

    // MARK: - loads profile data from archive
    static func loadProfile() -> ProfileData?{
        do{
            let data = try Data(contentsOf: ProfileData.profileResponseArchiveURL)
            let loadedProfile = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ProfileData
            return loadedProfile
        }catch{
            os_log(.error, log: OSLog.default, "failed to load profile")
        }
        return nil
    }
    
    // MARK: - saves profile data response into archive
    private func saveProfile(){
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: profile!, requiringSecureCoding: false)
            try data.write(to: ProfileData.profileResponseArchiveURL)
            os_log(.info, log: OSLog.default, "profile successfully saved in archive")
        }catch{
            os_log(.error, log: OSLog.default, "failed to save profile")
        }
    }

}
