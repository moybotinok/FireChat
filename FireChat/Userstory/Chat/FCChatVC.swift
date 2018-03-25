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


class FCChatVC: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FCMessageRecievedDelegate {

    private var messages = [JSQMessage]()
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        FCMessagesHandler.sharedInstance.delegate = self
        
        self.senderId = FCFirebaseAuthService.sharedInstance.userId()
        self.senderDisplayName = FCFirebaseDatabaseService.sharedInstance.userName
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FCMessagesHandler.sharedInstance.observeMessages()
        FCMessagesHandler.sharedInstance.observeMediaMessages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        FCMessagesHandler.sharedInstance.stopObserve()
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
        
        let message = messages[indexPath.item]
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        if (message.senderId == senderId) {
        
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.green)
            
        } else {
            
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.blue)
        }
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
    
    //MARK: - FCMessageRecievedDelegate
    
    func messageRecieved(senderId: String, senderName: String, text: String) {

        messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
        collectionView.reloadData()
        scrollToBottom(animated: true)
    }
    
    func mediaRecieved(senderId: String, senderName: String, url: String) {
        
        if let mediaURL = URL(string: url) {
            
            if url.contains("/\(Constants.IMAGE_STORAGE)") {
                
                URLSession.shared.dataTask(with: mediaURL) { [weak self] data, response, error in
                    
                    if let image = UIImage(data: data!) {
                        
                        DispatchQueue.main.async {
                            
                            let photo = JSQPhotoMediaItem(image: image)
                            
                            photo?.appliesMediaViewMaskAsOutgoing = (senderId == self?.senderId)

                            self?.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
                            
                            self?.collectionView.reloadData()
                            self?.scrollToBottom(animated: true)
                        }
                    }
                    }.resume()
                
            } else if url.contains("/\(Constants.VIDEO_STORAGE)") {
                
                let video = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true)
                video?.appliesMediaViewMaskAsOutgoing = (senderId == self.senderId)
                self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: video))
                
                self.collectionView.reloadData()
                scrollToBottom(animated: true)
            }
        }
    }
    
    // MARK: - Actions
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        FCMessagesHandler.sharedInstance.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text)
        
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
            
            let data = UIImageJPEGRepresentation(photo, 0.01)
            FCMessagesHandler.sharedInstance.sendMedia(image: data, video: nil, senderId: senderId, senderName: senderDisplayName)
            
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {

            FCMessagesHandler.sharedInstance.sendMedia(image: nil, video: videoURL, senderId: senderId, senderName: senderDisplayName)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
