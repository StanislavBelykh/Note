//
//  FolderModel.swift
//  Note
//
//  Created by Полина on 16.03.2020.
//  Copyright © 2020 Станислав Белых. All rights reserved.
//

import Foundation

struct Folder {
    var title: String
    var notes: [Note] = [Note(title: "Title", body: "Body", createDate: nil, editDate: nil)]
    
}
