//
//  Entry.swift
//  Grad Cafe
//
//  Created by Gohar Irfan on 2/17/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import Foundation

class Entry {
    let institution: String
    let program_season: String
    let decision: String
    let date_added: String
    let status: String
    let notes: String
    
    required init(institution: String, program_season: String, decision: String, date_added: String, status: String, notes: String) {
        self.institution = institution
        self.program_season = program_season
        self.decision = decision
        self.date_added = date_added
        self.status = status
        self.notes = notes
    }
}