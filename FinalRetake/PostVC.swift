//
//  PostVC.swift
//  FinalRetake
//
//  Created by MacBook on 6/1/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PostVC: UIViewController {

    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var addTextTextField: UITextView!
    
    @IBAction func addImage(_ sender: UIButton) {
        addImageButton.isEnabled = false
        addTextTextField.isEditable = false
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
   
    @IBAction func createPost(_ sender: UIBarButtonItem) {
        let dbRef = Database.database().reference()
        let storageRef = Storage.storage().reference()
        let key = dbRef.child("posts").childByAutoId().key
        let uploadImageRef = storageRef.child("images/\(key)")
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        if addImageButton.isEnabled == false && addTextTextField.text == "" {
                        let image = imageView.image
            guard let email = currentUser?.email else { return }
            guard let userId =  currentUser?.uid else { return }
                        let post = ["email"     : "\(email)",
                                    "text"      : "",
                                    "timestamp" : "\(formatter.string(from: currentDateTime))",
                                    "type"      : "image",
                                    "userId"    : "\(userId)",
                                    "imageURL"  : ""]
                    let childUpdates = ["/posts/\(key)": post]
                        dbRef.updateChildValues(childUpdates) { (error, dbRef) in
                            if let error = error {
                                print("Error Creating Post: \(error.localizedDescription)")
                            }
                        }
                        guard let data = UIImageJPEGRepresentation(image!, 1.0) else { print("image is nil"); return}
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        let uploadTask = uploadImageRef.putData(data, metadata: metadata) { (storageMetadata, error) in
                            if let error = error {
                                print("uploadTask error: \(error.localizedDescription)")
                            } else if let storageMetadata = storageMetadata {
                                print("storageMetadata: \(storageMetadata)")
                            }
                        }
            
                        // Listen for state changes, errors, and completion of the upload.
                        uploadTask.observe(.resume) { snapshot in
                            // Upload resumed, also fires when the upload starts
                        }
            
                        uploadTask.observe(.pause) { snapshot in
                            // Upload paused
                        }
            
                        uploadTask.observe(.progress) { snapshot in
                            // Upload reported progress
                            let percentProgress = 100.0 * Double(snapshot.progress!.completedUnitCount)
                                / Double(snapshot.progress!.totalUnitCount)
                            print(percentProgress)
                        }
            
                        uploadTask.observe(.success) { snapshot in
                            // Upload completed successfully
            
                            // set post's imageURL
                            //let imageURL = String(describing: snapshot.metadata!.downloadURL()!)
                            
                            
                            guard let imageURL = snapshot.metadata?.downloadURLs?.first?.absoluteString else { return }
                            
                            dbRef.child("posts/\(key)").updateChildValues(["imageURL" : imageURL], withCompletionBlock: { (error, dbRef) in
                                if let error = error {
                                    print("image url error: \(error.localizedDescription)")
                                } else {
                                    print("dbRef: \(dbRef)")
                                }
                            })
                            
                        }
            
        
    } else {
        guard let email = currentUser?.email else { return }
        guard let text = addTextTextField.text else { return }
        guard let userId =  currentUser?.uid else { return }
        let post = ["email"         : "\(email)",
                    "text"          : "\(text)",
                    "timestamp"     : "\(formatter.string(from: currentDateTime))",
                    "type"          : "text",
                    "userId"        : "\(userId)",
                    "imageURL"      : ""]
        let childUpdates = ["/posts/\(key)": post]
        dbRef.updateChildValues(childUpdates) { (error, dbRef) in
            if let error = error {
                print("Error Creating Post: \(error.localizedDescription)")
            }
        }
        


        }
    addTextTextField.text = ""
    addTextTextField.isEditable = true
    addImageButton.isEnabled = true
    imageView.image = nil
    tabBarController?.selectedIndex = 0
    }

}

extension PostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        addImageButton.isEnabled = true
        addTextTextField.isEditable = true
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        
        imageView.image = newImage
        dismiss(animated: true)
    }
}

