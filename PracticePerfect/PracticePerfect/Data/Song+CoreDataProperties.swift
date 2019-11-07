//
//  Song+CoreDataProperties.swift
//  
//
//  Created by Abigail Chen on 11/7/19.
//
//Rewritten when NSManagedObject subclasses are generated.

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var title: String?
    @NSManaged public var composer: String?
    @NSManaged public var id: Int16
    @NSManaged public var highScore: Int64

}
