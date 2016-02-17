//
//  DataController.swift
//  Grad Cafe
//
//  Created by Gohar Irfan on 2/17/16.
//  Copyright © 2016 Gohar Irfan. All rights reserved.
//

import Foundation
import Alamofire
import HTMLReader

let URLString = "http://thegradcafe.com/survey/index.php?q=computer+science&t=m&o=&pp=25"

class DataController {
    var entries: [Entry]?
    
    private func parseHTMLRow(rowElement: HTMLElement) -> Entry? {
        var institutionStr: String?
        var program_seasonStr: String?
        var decisionStr: String?
        var date_addedStr: String?
        var statusStr: String?
        var notesStr: String?
        
        if let firstColumn = rowElement.childAtIndex(0) as? HTMLElement {
            institutionStr = firstColumn.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString(",", withString: "")
        }
        
        // can't do anything without institution name, probably the row is not worthy of showing
        if (institutionStr == nil) {
            return nil
        }
        
        if let secondColumn = rowElement.childAtIndex(1) as? HTMLElement {
            program_seasonStr = secondColumn.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString(",", withString: "")
        }
        
        if let thirdColumn = rowElement.childAtIndex(2) as? HTMLElement {
            decisionStr = thirdColumn.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString(",", withString: "")
        }
        
        if let fourthColumn = rowElement.childAtIndex(3) as? HTMLElement {
            date_addedStr = fourthColumn.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString(",", withString: "")
        }
        
        if let fifthColumn = rowElement.childAtIndex(4) as? HTMLElement {
            statusStr = fifthColumn.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString(",", withString: "")
        }
        
        if let sixthColumn = rowElement.childAtIndex(5) as? HTMLElement {
            notesStr = sixthColumn.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByReplacingOccurrencesOfString(",", withString: "")
        }
        
//        // first column: institution
//        if let firstColumn = rowElement.childAtIndex(0) as? HTMLElement {
//            if let institutionNode = firstColumn.firstNodeMatchingSelector("td") {
//                if let institutionString = institutionNode.objectForKeyedSubscript("href") as? String {
//                    url = NSURL(string: urlString)
//                }
//                // need to make sure it's a number
//                let textNumber = firstColumn.textContent.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//                number = Int(textNumber)
//            }
//        }
//        if (url == nil || number == nil) {
//            return nil // can't do anything without a URL, e.g., the header row
//        }
        
//        if let secondColumn = rowElement.childAtIndex(3) as? HTMLElement {
//            let text = secondColumn.textContent
//                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//                .stringByReplacingOccurrencesOfString(",", withString: "")
//            scale = Int(text)
//        }
        
//        if let thirdColumn = rowElement.childAtIndex(5) as? HTMLElement {
//            title = thirdColumn.textContent
//                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//                .stringByReplacingOccurrencesOfString("\n", withString: "")
//        }
//        
//        if let title = title, url = url, number = number, scale = scale {
//            return Chart(title: title, url: url, number: number, scale: scale)
//        }
//        return nil
        let e = Entry(institution: institutionStr!, program_season: program_seasonStr!, decision: decisionStr!, date_added: date_addedStr!, status: statusStr!, notes: notesStr!)
        return e
    }
    
    private func isEntriesTable(tableElement: HTMLElement) -> Bool {
        if tableElement.children.count > 0 {
            if tableElement.innerHTML.containsString("dAccepted") || tableElement.innerHTML.containsString("dRejected") {
                return true
            }
        }
        return false
    }
    
    func fetchEntries(completionHandler: (NSError?) -> Void) {
        Alamofire.request(.GET, URLString)
            .responseString { responseString in
                guard responseString.result.error == nil else {
                    completionHandler(responseString.result.error!)
                    return
                    
                }
                guard let htmlAsString = responseString.result.value else {
                    let error = Error.errorWithCode(.StringSerializationFailed, failureReason: "Could not get HTML as String")
                    completionHandler(error)
                    return
                }
                
                let doc = HTMLDocument(string: htmlAsString)
                
                // find the table of Entries in the HTML
                let tables = doc.nodesMatchingSelector("tbody")
                var EntriesTable:HTMLElement?
                for table in tables {
                    if let tableElement = table as? HTMLElement {
                        if self.isEntriesTable(tableElement) {
                            EntriesTable = tableElement
                            break
                        }
                    }
                }
                
                // make sure we found the table of Entries
                guard let tableContents = EntriesTable else {
                    // TODO: create error
                    let error = Error.errorWithCode(.DataSerializationFailed, failureReason: "Could not find Entries table in HTML document")
                    completionHandler(error)
                    return
                }
                
                self.entries = []
                for row in tableContents.children {
                    if let rowElement = row as? HTMLElement { // TODO: should be able to combine this with loop above
                        if let newEntry = self.parseHTMLRow(rowElement) {
                            self.entries?.append(newEntry)
                        }
                    }
                }
                completionHandler(nil)
        }
    }
}
