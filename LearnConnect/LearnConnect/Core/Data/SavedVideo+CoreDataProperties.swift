//
//  SavedVideo+CoreDataProperties.swift
//  LearnConnect
//
//  Created by Ozgun Dogus on 27.11.2024.
//
//

import Foundation
import CoreData


extension SavedVideo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedVideo> {
        return NSFetchRequest<SavedVideo>(entityName: "SavedVideo")
    }

    @NSManaged public var downloadDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var isDownloaded: Bool
    @NSManaged public var localUrl: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var videoData: Data?
    @NSManaged public var videoUrl: String?

}

extension SavedVideo : Identifiable {

}
