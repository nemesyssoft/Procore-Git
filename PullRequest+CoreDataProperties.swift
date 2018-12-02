//
//  PullRequest+CoreDataProperties.swift
//  Procore Git
//
//  Created by Laurent Daudelin on 12/2/18.
//  Copyright © 2018 Nemesys Software. All rights reserved.
//
//

import Foundation
import CoreData


extension PullRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PullRequest> {
        return NSFetchRequest<PullRequest>(entityName: "PullRequest")
    }

    @NSManaged public var id: Int16
    @NSManaged public var url: URL?
    @NSManaged public var title: String?
    @NSManaged public var diffURL: URL?

}
