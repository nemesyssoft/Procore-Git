//
//  DataDownloader.swift
//  Procore Git
//
//  Created by Laurent Daudelin on 11/12/18.
//  Copyright © 2018 Nemesys Software. All rights reserved.
//

import UIKit

class DataDownloader: NSObject, URLSessionDelegate {
    
    let githubHostURL = "https://api.github.com/"
    var userAndProject: String?
    
    init(withUserAndProject userProject: String) {
        super.init()
        self.userAndProject = userProject
        if ((userAndProject?.range(of: "/")) != nil) {
            let url = URL.init(string: githubHostURL + userProject)!
            let task = URLSession.shared.pullRequestJSONTask(with: url) { pullRequestJSON, response, error in
                if let pullRequestJSON = pullRequestJSON {
                    let pullRequestsArray = [pullRequestJSON]
                }
            }
            task.resume()        }
    }
}
