//
//  MUConstants.h
//  MatchedUp
//
//  Created by Jimzy Lui on 12/7/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUConstants : NSObject

#pragma mark - User Class

extern NSString *const kMUUserTagLineKey;

extern NSString *const kMUUserProfileKey;
extern NSString *const kMUUserProfileNameKey;
extern NSString *const kMUUserProfileFirstNameKey;
extern NSString *const kMUUserProfileLocationKey;
extern NSString *const kMUUserProfileGenderKey;
extern NSString *const kMUUserProfileBirthdayKey;
extern NSString *const kMUUserProfileInterestedInKey;
extern NSString *const kMUUserProfilePictureURLKey;
extern NSString *const kMUUserProfileRelationshipStatusKey;
extern NSString *const kMUUserProfileAgeKey;

#pragma mark - Photo Class

extern NSString *const kMUPhotoClassKey;
extern NSString *const kMUPhotoUserKey;
extern NSString *const kMUPhotoPictureKey;

#pragma mark - Activity Class

extern NSString *const kMUActivityClassKey;
extern NSString *const kMUActivityTypeKey;
extern NSString *const kMUActivityFromUserKey;
extern NSString *const kMUActivityToUserKey;
extern NSString *const kMUActivityPhotoKey;
extern NSString *const kMUActivityTypeLikeKey;
extern NSString *const kMUActivityTypeDislikeKey;

#pragma mark - Settings

extern NSString *const kMUMenEnabledKey;
extern NSString *const kMUWomenEnabledKey;
extern NSString *const kMUSingleEnabledKey;
extern NSString *const kMUAgeMaxKey;

#pragma mark - ChatRoom

extern NSString *const kMUChatRoomClassKey;
extern NSString *const kMUChatRoomUser1Key;
extern NSString *const kMUChatRoomUser2Key;

#pragma mark - Chat

extern NSString *const kMUChatClassKey;
extern NSString *const kMUChatChatRoomKey;
extern NSString *const kMUChatFromUserKey;
extern NSString *const kMUChatToUserKey;
extern NSString *const kMUChatTextKey;



@end
