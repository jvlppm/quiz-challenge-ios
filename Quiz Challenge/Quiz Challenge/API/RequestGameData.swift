//
//  RequestGameData.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/15/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import Foundation

struct RequestGameData : APIRequest {
    typealias Response = GameData

    fileprivate(set) var resource: String

    init(id: String = "1") {
        self.resource = "quiz/\(id)"
    }
}
