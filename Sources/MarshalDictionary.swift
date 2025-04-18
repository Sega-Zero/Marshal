//
//  M A R S H A L
//
//       ()
//       /\
//  ()--'  '--()
//    `.    .'
//     / .. \
//    ()'  '()
//
//


import Foundation


// MARK: - Types

public typealias MarshalDictionary = [String: any Sendable]


// MARK: - Dictionary Extensions

extension Dictionary: MarshaledObject {
    public func optionalAny(for key: KeyType) -> (any Sendable)? {
        guard let aKey = key as? Key else { return nil }
        return self[aKey]
    }
}

/*
	On Swift platforms without the Objective-C runtime (like Linux),
	there’s no `NSObject.value(forKeyPath:)`. Given that it’s unlikely
	a client will be trying to use Objective-C in these	environments,
	conditionally compiling these extensions is probably okay.
*/

#if canImport(ObjectiveC)

extension NSDictionary: ValueType { }

extension NSDictionary: MarshaledObject {
    public func any(for key: KeyType) throws -> any Sendable {
        guard let value: any Sendable = self.value(forKeyPath: key.stringValue) else {
            throw MarshalError.keyNotFound(key: key)
        }
        if let _ = value as? NSNull {
            throw MarshalError.nullValue(key: key)
        }
        return value
    }
    
    public func optionalAny(for key: KeyType) -> (any Sendable)? {
        return self[key]
    }
}

#endif
