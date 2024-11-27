//
//  BookmarkedVideo+CoreDataProperties.swift
//  LearnConnect
//
//  Created by Ozgun Dogus on 27.11.2024.
//
//

import Foundation
import CoreData


extension BookmarkedVideo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkedVideo> {
        return NSFetchRequest<BookmarkedVideo>(entityName: "BookmarkedVideo")
    }

    @NSManaged public var bookmarkDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var videoUrl: String?

}

extension BookmarkedVideo : Identifiable {

}
