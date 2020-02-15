//
//  GameData.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/15/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import Foundation

struct GameData : Decodable {
    public var question: String
    public var answer: [String]
}
