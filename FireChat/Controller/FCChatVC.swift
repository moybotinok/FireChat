//
//  FCChatVC.swift
//  FireChat
//
//  Created by Tatiana Bocharnikova on 24.03.2018.
//  Copyright © 2018 Tatiana Bocharnikova. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit

class FCChatVC: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var messages = [JSQMessage]()
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.senderId = "1"
        self.senderDisplayName = "tany"
    }


    //MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.green)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "backImage"), diameter: 30)
    }
    
    
    //MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let message = messages[indexPath.item]
        
        if message.isMediaMessage {
            
            if let mediaItem = message.media as? JSQVideoMediaItem {
                
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerVC = AVPlayerViewController()
                playerVC.player = player
                present(playerVC, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - Actions
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, text: text))
        
        collectionView.reloadData()
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alert = UIAlertController(title: "Media", message: "Выбери файл", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Отмени", style: .cancel, handler: nil)
        
        let photos = UIAlertAction(title: "Фото", style: .default) { [weak self] (alertAction: UIAlertAction) in
            
            self?.chooseMedia(type: kUTTypeImage)
        }
        
        let video = UIAlertAction(title: "Видео", style: .default) { [weak self] (alertAction: UIAlertAction) in
            
            self?.chooseMedia(type: kUTTypeMovie)
        }
        
        alert.addAction(cancel)
        alert.addAction(photos)
        alert.addAction(video)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Image Picker
    
    private func chooseMedia(type: CFString) {
        
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let image = JSQPhotoMediaItem(image: photo)
            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: image))
            
            
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            
            let video = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
            collectionView.reloadData()
            
        }
        
        
        collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}
