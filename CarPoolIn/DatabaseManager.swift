//
//  DatabaseManager.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 21/11/23.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager{
    
    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addUser(_ user: User) {
        let userEntity = UserEntity(context: context)
        userEntity.firstName = user.firstName
        userEntity.lastName = user.lastName
        userEntity.email = user.email
        userEntity.age = user.age
        userEntity.sex = user.sex
        userEntity.mobNo = user.phoneNumber
        
        do {
            try context.save()
        }
        catch {
            print("User saving error", error)
        }
    }
    
    func doesUserExist(phoneNumber: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "mobNo == %@", phoneNumber)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        }
        catch {
            print("Fetch error", error)
            return false
        }
    }
    
    func fetchUser(phoneNumber: String) -> UserEntity? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "mobNo == %@", phoneNumber)
        
        do {
            let result = try context.fetch(fetchRequest) as? [UserEntity]
            return result![0]
        }
        catch {
            print("Fetch error", error)
            return nil
        }
    }
    
    func addFindRide(_ findRide: FindRide) {
        let findRideEntity = FindRideEntity(context: context)
        findRideEntity.origin = findRide.origin
        findRideEntity.destination = findRide.destination
        findRideEntity.phoneNumber = findRide.phoneNumber
        do {
            try context.save()
        }
        catch {
            print("Find Ride saving error", error)
        }
    }
    
    func addOfferRide(_ offerRide: OfferRide) {
        let offerRideEntity = OfferRideEntity(context: context)
        offerRideEntity.origin = offerRide.origin
        offerRideEntity.destination = offerRide.destination
        offerRideEntity.phoneNumber = offerRide.phoneNumber
        offerRideEntity.plateNumber = offerRide.plateNumber
        offerRideEntity.date = Date()
        do {
            try context.save()
        }
        catch {
            print("Find Ride saving error", error)
        }
    }
    
    func fetchExistingRides() -> [OfferRideEntity]
    {
        var existingRides: [OfferRideEntity] = []
        
        do{
            existingRides = try context.fetch(OfferRideEntity.fetchRequest())
        }catch{
            print("Fetch user error", error)
        }
        return existingRides
        
    }
    
    func fetchFilteredRide(origin: String, destination: String) -> [OfferRideEntity] {
        var existingRides: [OfferRideEntity] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfferRideEntity")
        fetchRequest.predicate = NSPredicate(format: "origin == %@ AND destination == %@", origin, destination)
        do{
            existingRides = try (context.fetch(fetchRequest) as? [OfferRideEntity])!
        }catch{
            print("Fetch user error", error)
        }
        return existingRides
    }
}
