//
//  DataDownloader.swift
//  Procore Git
//
//  Created by Laurent Daudelin on 11/12/18.
//  Copyright © 2018 Nemesys Software. All rights reserved.
//

import UIKit

class DataDownloader: NSObject, URLSessionDelegate {
    
    let githubHostURL = "https://api.github.com/repos/"
    var userAndProject: String?
    
    override init() {
        super.init()
    }
    
    func downloadPullRequests(user: String, repo: String, completionHandler: @escaping (PullRequestJSON?, Error?) -> Void) {
        let userAndRepo = user + "/" + repo
        
        guard let url = URL(string: githubHostURL + userAndRepo + "/pulls") else {
            print("Error: cannot create Pull Requests URL")
            return
        }
        print("URL: \(url)")
        
        let task = URLSession.shared.pullRequestJSONTask(with: url) { pullRequestJSON, response, error in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            if let pullRequestJSON = pullRequestJSON {
                completionHandler(pullRequestJSON, nil)
            }
            else {
                if response != nil {
                    let urlResponse = response as! HTTPURLResponse
                    if urlResponse.statusCode == 404 {
                        let notFoundError = NSError.init(domain: "ProCore Git", code: 404, userInfo: nil)
                        completionHandler(nil, notFoundError)
                    }
                }
            }
        }
        task.resume()
    }
    
    func downloadPullRequestsFileChanged(user: String, repo: String, pullRequestNumber: Int, completionHandler: @escaping (PullRequestFilesChangedJSON?, Error?) -> Void) {
        let urlAsString = githubHostURL + user + "/" + repo + "/pulls/\(pullRequestNumber)/files"
        guard let url = URL(string: urlAsString) else {
            print("Error: cannot create Pull Requests URL")
            return
        }
        print("URL: \(url)")
        
        let task = URLSession.shared.pullRequestFilesChangedJSONTask(with: url) { pullRequestFilesChangedJSON, response, error in
            if let pullRequestFilesChangedJSON = pullRequestFilesChangedJSON {
                completionHandler(pullRequestFilesChangedJSON, nil)
            }
        }
        task.resume()
    }
}
