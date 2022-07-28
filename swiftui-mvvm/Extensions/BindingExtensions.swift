import Foundation
import SwiftUI

// Extension on Binding to receive a generic type and create the following
// declaration with the type previously assigned to the object:
// Binding(get: { object }, set: { object = $0})
//
// Reducing boilerplate and resulting in the following declaration:
// Binding(to: \.object, on: self)
//
// Shouldn't be used in cases that the ViewModel references itself,
// as it closes a cycle, resulting in RetainCycle problems.
extension Binding {
    init<ObjectType: AnyObject>(
        to path: ReferenceWritableKeyPath<ObjectType, Value>,
        on object: ObjectType
    ) {
        self.init(
            get: { object[keyPath: path] },
            set: { object[keyPath: path] = $0 }
        )
    }
}
