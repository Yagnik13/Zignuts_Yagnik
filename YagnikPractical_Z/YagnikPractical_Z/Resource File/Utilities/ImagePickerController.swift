//
//  ImagePickerController.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit
import AVFoundation

class ImagePickerController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Properties
    fileprivate lazy var imagePickerController: CoreImagePickerController = {
        let ipc = CoreImagePickerController()
        ipc.delegate = self
        return ipc
    }()
    static let shared = ImagePickerController()
    var imagePickedCompletion: ((_ pickedImage: UIImage?,_ imageName: String?, _ cancelled: Bool, _ removed: Bool)->()) = { _, _, _,_   in }
    
    //MARK: - Methods
    func showPicker(onController viewController: UIViewController, withRemoveOption: Bool = false, completion: @escaping (_ pickedImage: UIImage?,_ imageName: String?, _ cancelled: Bool, _ removed: Bool)->Void) {
        var options = [("Camera".localized, false),("Photos".localized, false)]
        if withRemoveOption {
            options.append(("Remove Image".localized, true))
        }
        CustomAlertController.showActionSheet(forTitle: "", message: "Choose any option".localized, sender: viewController, withActionTitles: options, isCancellable: true) { (index) in
            self.imagePickedCompletion = completion
            switch index {
            case 0:
                self.imagePickerController.sourceType = .camera
                self.checkPermission(completion: { (isGranted) in
                    if isGranted {
                        viewController.present(self.imagePickerController, animated: true, completion: nil)
                    } else {
                        CustomAlertController.showAlertWithOkCancel(forTitle: "Camera permission needed!".localized, message: "Please grant camera permission to capture photos".localized, sender: viewController, okTitle: "Settings".localized, okCompletion: {
                            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettingsURL) {
                                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                            }
                        }, cancelCompletion: nil)
                    }
                })
                break
            case 1:
                self.imagePickerController.sourceType = .photoLibrary
                viewController.present(self.imagePickerController, animated: true, completion: nil)
                break
            case 2:
                completion(nil,nil,!withRemoveOption, withRemoveOption)
                return
            default:
                break
            }
        }
    }
    
    private func checkPermission(completion: @escaping boolCompletion) {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            completion(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
         print(fileUrl.lastPathComponent)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage , let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            imagePickedCompletion(image,fileUrl.lastPathComponent, false, false)
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imagePickedCompletion(nil,nil, true, false)
    }
}

private class CoreImagePickerController: UIImagePickerController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.appGreen
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.sfUIDisplayRegular.getFont(withSize: 17)]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}
