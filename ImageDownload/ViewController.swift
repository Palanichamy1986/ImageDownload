//
//  ViewController.swift
//  ImageDownload
//
//  Created by Palanichamy Padmanabhan on 27/11/18.
//  Copyright © 2018 Palanichamy Padmanabhan. All rights reserved.
//

import UIKit

enum BigImages: String {
    case whale = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe5127_whale/whale.jpg"
    case shark = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe5123_shark/shark.jpg"
    case seaLion = "https://d17h27t6h515a5.cloudfront.net/topher/2017/November/59fe511f_sealion/sealion.jpg"
}

class ViewController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sliderDragged(_ sender: UISlider) {
        imgView.alpha = CGFloat(sender.value)
    }
    
    // MARK: - Sync Download
    
    // this method downloads a huge image, blocking the main queue and the UI
    // (for instructional purposes only, never do this in a production app)
    @IBAction func btnSyncDownloadClicked(_ sender: UIBarButtonItem) {
        // start animation
        activityIndicator.startAnimating()
        
        // use url to get the data for the image
        if let url = URL(string:BigImages.seaLion.rawValue) , let imgData = try? Data(contentsOf: url)
        {
            // turn data into an image
            let image = UIImage(data: imgData)
            
            // display it
            imgView.image = image
            
            // stop animating
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Async Download
    
    // this method avoids blocking by creating a background queue, without blocking the UI
    @IBAction func btnAsyncDownloadClicked(_ sender: UIBarButtonItem) {
        // start animation
        activityIndicator.startAnimating()
        
        // create a queue
        let downloadQueue = DispatchQueue(label:"download",qos:.userInitiated)
        
        // run the blocking operation in the background
        downloadQueue.async {
            // use url to get the data for the image
                if let url = URL(string: BigImages.shark.rawValue), let imgData = try? Data(contentsOf: url)
                {
                    // turn data into an image
                    let image = UIImage(data: imgData)
                    
                    // run  code that updates the UI on the main queue
                    DispatchQueue.main.async {
                        // display it
                        self.imgView.image = image
                        
                        // stop animating
                        self.activityIndicator.stopAnimating()
                    }
                   
            }
        }
    }
    
    // MARK: - Async Download (with Completion Handler)

    @IBAction func btnAsyncCompletionClicked(_ sender: UIBarButtonItem) {
        // start animation
        activityIndicator.startAnimating()
        
        downloadBigImage { (image) in
            // display it
            self.imgView.image = image
            
            // stop animating
            self.activityIndicator.stopAnimating()
        }
    }
    
    // this method downloads a huge image on a global queue
    // once finished, the completion closure runs with the image
    func downloadBigImage(completionHandler handler:@escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos:.userInitiated).async {
            // use url to get the data for the image
            if let url = URL(string:BigImages.whale.rawValue), let imgData = try? Data(contentsOf: url) {
                // turn data into an image
                let image = UIImage(data: imgData)
                
                // always run completion handler in the main queue, just in case!
                DispatchQueue.main.async {
                    handler(image)
                }
            }
        }
    }
    
    
}

