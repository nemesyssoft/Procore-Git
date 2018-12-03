//
//  DataSource.swift
//  Procore Git
//
//  Created by Laurent Daudelin on 12/2/18.
//  Copyright © 2018 Nemesys Software. All rights reserved.
//

import Foundation
import CoreData

class DataSource: NSObject {
    var managedObjectContext: NSManagedObjectContext?
    
    init(withContext managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init()
    }
    
    func savePullRequests(pullRequests pullRequestsArray: PullRequestJSON) {
        for aPullRequestJSON in pullRequestsArray {
            let aManagedObject = NSEntityDescription.insertNewObject(forEntityName: "PullRequest", into: managedObjectContext!)
            let aPullRequest = aManagedObject as! PullRequest
            aPullRequest.title = aPullRequestJSON.title
            if let id = aPullRequestJSON.id {
                let nsNumber = NSNumber.init(value: id)
                aPullRequest.id = Int16(truncating: nsNumber)
            }
            if let number = aPullRequestJSON.number {
                let nsNumber = NSNumber.init(value: number)
                aPullRequest.number = Int32(truncating: nsNumber)
            }
            aPullRequest.diffURL = URL.init(string: aPullRequestJSON.diffURL!)
            aPullRequest.url = URL.init(string: aPullRequestJSON.url!)
        }
        if (managedObjectContext?.hasChanges)! {
            do {
                try managedObjectContext?.save()
            } catch
            {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func pullRequestsCount() -> Int {
        let fetchRequest: NSFetchRequest<PullRequest> = PullRequest.fetchRequest()
        var pullsCount = 0
        do {
            pullsCount = try (managedObjectContext?.count(for: fetchRequest))!
        } catch {
            print("Error while trying to count pull requests")
        }
        return pullsCount
    }
}
