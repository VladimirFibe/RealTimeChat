import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    private let database = Database.database().reference()
    
}
// MARK: - Account Managment
extension DatabaseManager {

    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.uid).setValue([
            "email": user.emailAddress,
            "first_name": user.firstName,
            "last_name": user.lastName])
    }
}
