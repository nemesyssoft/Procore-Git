//
//  DetailViewController.swift
//  Procore Git
//
//  Created by Laurent Daudelin on 11/11/18.
//  Copyright © 2018 Nemesys Software. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var diffTextView: UITextView!
    var diffText: String!
    var user: String!
    var repo: String!
    var pullRequestNumber: Int!

    func configureView() {
        // Update the user interface for the detail item.
        if diffText != nil {
            diffTextView.text = diffText
        }
        else if user != nil && repo != nil && pullRequestNumber != nil {
            let dataDownloader = DataDownloader.init()
            dataDownloader.downloadPullRequestsFileChanged(user: user, repo: repo, pullRequestNumber: pullRequestNumber) { (pullRequestFilesChangedJSON: PullRequestFilesChangedJSON?, error: Error?) in
                if error == nil {
                    for aChangedFile in pullRequestFilesChangedJSON! {
                        OperationQueue.main.addOperation {
                            self.diffTextView.text.append(aChangedFile.patch!)
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: PullRequest? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

