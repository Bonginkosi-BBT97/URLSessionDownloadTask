//
//  ViewController.swift
//  URLSessionDownloadTask
//
//  Created by Bonginkosi Tshabalala on 2023/04/07.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate {
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var downloadImageView: UIImageView!
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        progressBar.progress = 0
        percentageLabel.text = "0.0"
    }
    
    
    @IBAction func downloadBtnClicked(_ sender: UIButton) {
        percentageLabel.isHidden = false
        downloadImageView.image = nil
        let urlString = "https://i0.wp.com/fountainavenuekitchen.com/wp-content/uploads/2013/01/IMG_0979.jpg?fit=2048%2C1536&ssl=1"
        
        guard let url = URL(string: urlString) else {
            print("This is an invalid URL")
            return
        }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        session.downloadTask(with: url).resume()
        
            // URLSession.shared.downloadTask(with: url) { fileURL, response, error in
            //            if let error = error {
            //                print("The error is: \(error.localizedDescription)")
            //            } else {
            //                print("The URL to the downloaded file is: \(fileURL)")
            //            }
            //        } .resume()
        }
    }
extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else  {
            print("The data could not be loaded")
            return
        }
        let image = UIImage (data: data)
        DispatchQueue.main.async { [weak self] in
            self?.downloadImageView.image = image
            self?.percentageLabel.isHidden = true
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress =  Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async { [weak self] in
            self?.progressBar.progress = progress
            self?.percentageLabel.text = "\(progress * 100)%"
        }
        
        print("The progress is: \(progress)")
        
    }
}
