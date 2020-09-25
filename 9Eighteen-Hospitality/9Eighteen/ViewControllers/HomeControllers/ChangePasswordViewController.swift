//
//  ChangePasswordViewController.swift
//  9Eighteen
//
//  Created by vijaykumar Tanala on 15/07/19.
//  Copyright © 2019 vijaykumar Tanala. All rights reserved.
//

import UIKit
import SDWebImage

typealias Parameters = [String: String]

class ChangePasswordViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var isEdit : Bool!
    var firstName : String!
    var lastName : String!
    var email : String!
    var imageUrl : String!
    var foreup_user_id : String!
    
    private let myPickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.borderWidth = 3
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor(hexString: "#0C6E4C").cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        uploadButton.isHidden = false
        if isEdit == true {
            self.navigationItem.title = "Update Profile"
            currentPassword.placeholder! = "First Name"
            newPassword.placeholder! = "Last Name"
            confirmPassword.placeholder! = "Email"
            currentPassword.text! = firstName
            newPassword.text! = lastName
            confirmPassword.text! = email
            self.profileImage.sd_setImage(with: URL(string: imageUrl ?? ""), placeholderImage: UIImage(named: "user"))
        }
        else {
            uploadButton.isHidden = true
            self.navigationItem.title = "Change Password"
            profileImage.image = UIImage(named: "changepassword")
        }
    }
    
    
    @IBAction func submitButton(_ sender: NineEighteenButton) {
        if isEdit == true {
            if currentPassword.text!.isEmpty || confirmPassword.text!.isEmpty || newPassword.text!.isEmpty {
                NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "All fields are manditory", cancelButtonTitle: "OK", presentViewController: self)
            }else{
                updateProfile()
            }
        }
        else {
            if currentPassword.text!.isEmpty || confirmPassword.text!.isEmpty || newPassword.text!.isEmpty {
                NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "All fields are manditory", cancelButtonTitle: "OK", presentViewController: self)
            }
            else if confirmPassword.text! == newPassword.text! {
                changePassword()
            }
            else {
                NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Confirm password and new password are not matched ", cancelButtonTitle: "OK", presentViewController: self)
            }
        }
    }
    private func changePassword() {
        FSActivityIndicatorView.shared.show()
        let details = ["phoneNumber": dataTask.LoginData().mobileNo!, "password": confirmPassword.text!]
        ModelParser.postApiServices(urlToExecute: URL(string:NineEighteenApis.password)!, parameters: details, methodType: "POST", accessToken: false) { (response,error) in
            DispatchQueue.main.async {
                if let unwrappedError = error {
                    FSActivityIndicatorView.shared.dismiss()
                    print(unwrappedError.localizedDescription)
                }
                if let json = response {
                    FSActivityIndicatorView.shared.dismiss()
                    guard let success = json["success"] as? Bool else {return}
                    if success == true {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                
            }
        }
    }
    
    private func updateProfile() {
        FSActivityIndicatorView.shared.show()
        let details = ["user_id": dataTask.LoginData().user_id!,"foreup_user_id": foreup_user_id!, "firstName": currentPassword.text! , "lastName" : newPassword.text! , "email" : confirmPassword.text!, "phone" : dataTask.LoginData().mobileNo!,"foreupCourseId":dataTask.LoginData().forupId!,"course_id":dataTask.LoginData().courseId!]
        
        guard let mediaImage = Media(withImage: profileImage.image!, forKey: "file") else { return }
        
        guard let url = URL(string:NineEighteenApis.updateProfile) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("https://qa.9-eighteen.com", forHTTPHeaderField: "origin")
        let dataBody = createDataBody(withParameters: details, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        DispatchQueue.main.async {
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let _ = response {}
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                            DispatchQueue.main.async {
                                guard let success = json["success"] as? Bool else{return}
                                if success == true {
                                    FSActivityIndicatorView.shared.dismiss()
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                } else {
                                    FSActivityIndicatorView.shared.dismiss()
                                    NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                                }
                            }
                            
                        }
                        
                    } catch {
                        FSActivityIndicatorView.shared.dismiss()
                        NineEighteenAlertController.showCancelAlertController(title: "Oops!", message: "Something went wrong", cancelButtonTitle: "OK", presentViewController: self)
                    }
                }
                
            }.resume()
        }
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        showActionSheet()
    }
    
    private func showActionSheet() {
        myPickerController.delegate = self
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.myPickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(self.myPickerController, animated: true, completion: nil)
            } else {
                print("No Camera Available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.myPickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]as? UIImage
        picker.dismiss(animated: false, completion: { () -> Void in
            var imageCropVC : RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: image!, cropMode: RSKImageCropMode.circle)
            imageCropVC.delegate = self
            self.navigationController?.pushViewController(imageCropVC, animated: true)
            
        })
        //self.dismiss(animated: true, completion: nil);
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension ChangePasswordViewController: RSKImageCropViewControllerDelegate {
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.profileImage.image = croppedImage
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
