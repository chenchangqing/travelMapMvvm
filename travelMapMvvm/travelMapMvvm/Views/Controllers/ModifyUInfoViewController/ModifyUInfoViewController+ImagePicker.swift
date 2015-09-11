//
//  ModifyUInfoViewController+ImagePicker.swift
//  travelMapMvvm
//
//  Created by green on 15/9/9.
//  Copyright (c) 2015年 travelMapMvvm. All rights reserved.
//

import Foundation

extension ModifyUInfoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let compressedImage = PhotoHelper.compressImage(selectedImage)
        
        // 上传头像
        self.modifyUInfoViewModel.uploadHeadImageCommand.execute(compressedImage)
        
        self.imagePickerVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.imagePickerVC.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - imagePicker
    
    /**
     * 图片选择器设置
     */
    func setupImagePickerVC() {
        
        imagePickerVC = UIImagePickerController()
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
    }
    
    /**
     * 打开相册
     */
    func openPhotoLibrary() {
        
        if !PhotoHelper.isCanVisitPhotos(self) {  return }
        
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            self.presentViewController(self.imagePickerVC, animated: true, completion: {})
        }
    }
    
    /**
     * 打开相机
     */
    func openCamera() {
        
        if !PhotoHelper.isCanVisitCamera(self) { return }
        
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            self.presentViewController(self.imagePickerVC, animated: true, completion: {})
        }
    }
}