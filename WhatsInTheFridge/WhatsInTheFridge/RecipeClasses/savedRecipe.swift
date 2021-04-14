//
//  savedRecipe.swift
//  WhatsInTheFridge
//
//  Created by D on 4/14/21.
//

import UIKit

class savedRecipe: Recipe {
    //Mark: Archiving paths to data storage. This is a core difference between likedRecipes and savedRecipes.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("savedRecipes")
}
