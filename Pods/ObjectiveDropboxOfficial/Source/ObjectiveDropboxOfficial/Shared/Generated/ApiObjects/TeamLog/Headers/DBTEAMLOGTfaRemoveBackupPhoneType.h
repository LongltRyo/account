///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGTfaRemoveBackupPhoneType;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `TfaRemoveBackupPhoneType` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGTfaRemoveBackupPhoneType : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// (no description).
@property (nonatomic, readonly, copy) NSString *description_;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param description_ (no description).
///
/// @return An initialized instance.
///
- (instancetype)initWithDescription_:(NSString *)description_;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `TfaRemoveBackupPhoneType` struct.
///
@interface DBTEAMLOGTfaRemoveBackupPhoneTypeSerializer : NSObject

///
/// Serializes `DBTEAMLOGTfaRemoveBackupPhoneType` instances.
///
/// @param instance An instance of the `DBTEAMLOGTfaRemoveBackupPhoneType` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGTfaRemoveBackupPhoneType` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGTfaRemoveBackupPhoneType *)instance;

///
/// Deserializes `DBTEAMLOGTfaRemoveBackupPhoneType` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGTfaRemoveBackupPhoneType` API object.
///
/// @return An instantiation of the `DBTEAMLOGTfaRemoveBackupPhoneType` object.
///
+ (DBTEAMLOGTfaRemoveBackupPhoneType *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END