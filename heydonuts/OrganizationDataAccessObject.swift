//
//  OrganizationDataAccessObject.swift
//  heydonuts
//
//  Created by Brian Hildebrand on 4/3/17.
//  Copyright © 2017 Brian Hildebrand. All rights reserved.
//

import Foundation
import SQLite
import CryptoSwift

class OrganizationDataAccessObject {
    
    private let DASKey = Expression<String>("DASKey")
    private let organizations = Table("organizations")

    static let instance = OrganizationDataAccessObject()
    private let db: Connection?
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .applicationSupportDirectory, .userDomainMask, true
            ).first! + Bundle.main.bundleIdentifier!
        
        do{
            db = try Connection("\(path)/db.sqlite3")
        }
        catch {
            db = nil
            print("error")
        }
        
    }
    
    func createOrganizationsTableIfNotExists() {
        
        let organizations = Table("organizations")
        do{
            try db!.run(organizations.create(ifNotExists: true) { t in
                t.column(DASKey)
            })
        }
        catch {
            print("error")
            return
        }
        
    }
    
    func presetRWB() {
        updateKey(recordKey: "4duIyZ4lYE5448rAueRVB3Y92uWidl5V")
    }
    
    func updateKey(recordKey: String){
        
        do{
            try db!.run(organizations.update(DASKey <- recordKey))
        } catch{
            print("error inserting new organization into table")
            return
        }
    }
    
    func getCurrentKey() -> String {
        var currentKey: String = ""
        
        do {
            for record in try db!.prepare(organizations) {
                currentKey = record[DASKey]
            }
        } catch {
            print("error getting current das key")
            return ""
        }
        return currentKey
    }
    
    
}

