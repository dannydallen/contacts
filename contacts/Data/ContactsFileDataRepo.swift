//
//  ContactsFileDataRepo.swift
//  contacts
//
//  Created by Danny Allen on 5/21/18.
//  Copyright © 2018 Milo Croton. All rights reserved.
//

import Foundation

class ContactsFileDataRepo: ContactsDataRepo
{
    let dataFileName = "ContactsData.json"
    let primerFileName = "PrimerData"
    
    func requestContacts(response: @escaping (Bool, [Contact]) -> Void) {
        DispatchQueue.global().async {
            if self.dataFileExists() {
                if let data = self.loadData() {
                    response(true, data)
                }
                else {
                    response(false, [Contact]())
                }
            }
            else {
                let primerData = self.loadPrimerData()
                if primerData != nil {
                    response(true, primerData!)
                }
                else {
                    response(false, [Contact]())
                }
            }
        }
    }
    
    func requestSaveContacts(contacts: [Contact], response: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            response(self.saveData(contacts: contacts))
        }
    }
    
    private func loadPrimerData() -> [Contact]? {
        guard let path = Bundle.main.path(forResource: primerFileName, ofType: "json") else { return nil }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let contacts = try JSONDecoder().decode([Contact].self, from: data)
            
            return contacts
        }
        catch {}
        
        return nil
    }
    
    private func dataFileUrl() -> URL? {
        let fileManager = FileManager.default
        
        do {
            let url = try fileManager.url(for: .documentDirectory,
                                          in: .userDomainMask,
                                          appropriateFor: nil,
                                          create: false)
            return url.appendingPathComponent(dataFileName)
        }
        catch {
            return nil
        }
    }
    
    private func dataFileExists() -> Bool {
        let fileManager = FileManager.default
        
        if let url = dataFileUrl() {
            return fileManager.fileExists(atPath: url.path)
        }
        else {
            return false
        }
    }
    
    private func loadData() -> [Contact]? {
        guard dataFileExists() else { return nil }
        
        if let url = dataFileUrl() {
            do {
                let data = try Data(contentsOf: url)
                let contacts = try JSONDecoder().decode([Contact].self, from: data)
            
                return contacts
            }
            catch { }
            
            return [Contact]()
        }
        else {
            return nil;
        }
    }
    
    private func saveData(contacts:[Contact]) -> Bool {
        do {
            let jsonData = try JSONEncoder().encode(contacts)
    
            if let url = dataFileUrl() {
                try jsonData.write(to: url)
                return true
            }
            else {
                return false
            }
        }
        catch {
            return false
        }
    }
}
