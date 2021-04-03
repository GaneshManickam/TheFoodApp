//
//  DBManager.swift
//  TheFoodApp
//
//  Created by Ganesh Manickam on 03/04/21.
//

import Foundation
import RealmSwift

class DBManager {
    
    private init() {
        print("Realm File Path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    
    static let shared = DBManager()
    
    var realm: Realm!
    
    //Write to the table with table with primary key.
    func createWithPrimaryKey<T: Object>(_ object: T) {
        createRealmObject {
            do {
                try self.realm.write {
                    self.realm.add(object, update: .all)
                }
            } catch {
                print(error)
            }
        }
    }
    
    //Write to the table with table with primary key.
    func createWithPrimaryKey<T: Object>(_ object: List<T>) {
        DispatchQueue.main.async {
            self.createRealmObject {
                do {
                    try self.realm.write {
                        self.realm.add(object, update: .all)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    //Write to the table without primary key.
    func create<T: Object>(_ object: T) {
        self.createRealmObject {
            do {
                try self.realm.write {
                    self.realm.add(object)
                }
            } catch {
                print(error)
            }
        }
    }
    
    //Write to the table without primary key.
    func create<T: Object>(_ object: List<T>) {
        self.createRealmObject {
            do {
                try self.realm.write {
                    self.realm.add(object)
                }
            } catch {
                print(error)
            }
        }
    }
    
    //Read the object data
    func read<T: Object>(_ object: T) -> Results<T> {
        createRealmObject {
        }
        return realm.objects(T.self)
    }

    //Read the object data
    func read<T: Object>(_ object: T, completion: @escaping ((Results<T>) -> Void)){
        createRealmObject {
            completion(self.realm.objects(T.self))
        }
    }
    
    func deleteObject<T: Object>(_ object: T) {
        createRealmObject {
            
            if object.isInvalidated {
                return
            }
            
            do {
                try self.realm.write {
                    self.realm.delete(object)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func deleteObject<T: Object>(_ object: List<T>) {
        createRealmObject {
            do {
                try self.realm.write {
                    self.realm.delete(object)
                }
            } catch {
                print(error)
            }
        }
    }

    
    
    
    private func createRealmObject(completion: @escaping (() -> Void)) {
        if self.realm == nil {
            do {
                let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
                })
                
                self.realm = try Realm(configuration: config)
                completion()
            } catch {
                deleteRealmFileFromDevice()
                
                do {
                    realm = try Realm()
                    completion()
                } catch {
                    print(error)
                }
            }
        } else {
            completion()
        }
    }
    
    func deleteRealmFileFromDevice() {
        let fileNameToDelete = "default.realm"
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
                print("Realm removed successfully")
            } else {
                print("File does not exist")
            }
            
        } catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    func clearTheDatabase() {
        createRealmObject {
            do {
                try self.realm.write {
                    self.realm.deleteAll()
                }
            } catch {
                
            }
        }
    }
    
    func deleteRealmObject(idMeal: String) {
        createRealmObject { [self] in
            do {
                let object = self.realm.objects(SavedReceipe.self).filter("idMeal = %@", idMeal).first
                try! self.realm.write {
                    if let obj = object {
                        self.realm.delete(obj)
                    }
                }

            } catch let error as NSError {
                // handle error
                print("error - \(error.localizedDescription)")
            }
        }
    }
}
