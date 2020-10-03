//
//  TrailerViewController.swift
//  flixster
//
//  Created by Thu Do on 10/2/20.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController,WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    var movie : [String:Any]!
    var videos : [[String:Any]]!
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let id = movie["id"] as! NSNumber
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.videos = dataDictionary["results"] as! [[String:Any]]
                if self.videos.count > 0{
                    let first = self.videos[0]
                    let videoKey = first["key"] as! String
                    let urlString = "https://www.youtube.com/watch?v=\(videoKey)"
                    let myURL = URL(string:urlString)
                    let myRequest = URLRequest(url: myURL!)
                    self.webView.load(myRequest)
                    
                }

           }
        }
        task.resume()
        
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
