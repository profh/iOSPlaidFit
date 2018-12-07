//
//  CoreData.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 12/7/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation
import CoreData

class CoreData {
    
    func checkUser(_ appDelegate: AppDelegate) -> User? {
        var user: User?
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                user = self.loadUser(data)
                print("User successfully loaded")
            }
        } catch {
            print("Failed to load user")
        }
        if let u = user {
            return u
        } else {
            return nil
        }
    }
    
    func saveUser(_ appDelegate: AppDelegate, _ user: User) {
        // Connect to the context for the container stack
        let context = appDelegate.persistentContainer.viewContext
        // Specifically select the People entity to save this object to
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        // Set values one at a time and save
        newUser.setValue(user.id, forKey: "id")
        newUser.setValue(user.team_id, forKey: "team_id")
        newUser.setValue(user.first_name, forKey: "first_name")
        newUser.setValue(user.last_name, forKey: "last_name")
        newUser.setValue(user.andrew_id, forKey: "andrew_id")
        newUser.setValue(user.email, forKey: "email")
        newUser.setValue(user.phone_number, forKey: "phone_number")
        newUser.setValue(user.role, forKey: "role")
        newUser.setValue(user.year, forKey: "year")
        newUser.setValue(user.major, forKey: "major")
        newUser.setValue(user.missing_post_boolean, forKey: "missing_post_boolean")
        newUser.setValue(user.missing_daily_boolean, forKey: "missing_daily_boolean")
        newUser.setValue(user.api_key, forKey: "api_key")
        newUser.setValue(user.team_string, forKey: "team_string")
        do {
            try context.save()
            print("successfully saved user!")
        } catch {
            print("Failed saving user")
        }
    }
    
    func loadUser(_ data: NSManagedObject) -> User {
        let id = data.value(forKey: "id") as! Int
        let team_id = data.value(forKey: "team_id") as! Int
        let first_name = data.value(forKey: "first_name") as! String
        let last_name = data.value(forKey: "last_name") as! String
        let andrew_id = data.value(forKey: "andrew_id") as! String
        let email = data.value(forKey: "email") as! String
        let phone_number = data.value(forKey: "phone_number") as! String
        let role = data.value(forKey: "role") as! String
        let year = data.value(forKey: "year") as! String
        let major = data.value(forKey: "major") as! String
        let missing_post_boolean = data.value(forKey: "missing_post_boolean") as! Bool
        let missing_daily_boolean = data.value(forKey: "missing_daily_boolean") as! Bool
        let api_key = data.value(forKey: "api_key") as! String
        let team_string = data.value(forKey: "team_string") as! String
        return User(id: id, team_id: team_id, first_name: first_name, last_name: last_name, andrew_id: andrew_id, email: email, phone_number: phone_number, role: role, year: year, major: major, missing_daily_boolean: missing_daily_boolean, missing_post_boolean: missing_post_boolean, api_key: api_key, team_string: team_string)
    }

    func deleteUser(_ appDelegate: AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                // if the contact we are deleting is the same as this one in CoreData {
                context.delete(data)
                try context.save()
            }
        } catch {
            print("Failed")
        }
    }
    
}
