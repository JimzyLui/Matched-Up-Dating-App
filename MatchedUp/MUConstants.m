//
//  MUConstants.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/7/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MUConstants.h"

@implementation MUConstants

#pragma mark - User Class

NSString *const kMUUserTagLineKey               = @"tagLine";

NSString *const kMUUserProfileKey               = @"profile";
NSString *const kMUUserProfileNameKey           = @"name";
NSString *const kMUUserProfileFirstNameKey      = @"firstName";
NSString *const kMUUserProfileLocationKey       = @"location";
NSString *const kMUUserProfileGenderKey         = @"gender";
NSString *const kMUUserProfileBirthdayKey       = @"birthday";
NSString *const kMUUserProfileInterestedInKey   = @"interestedIn";
NSString *const kMUUserProfilePictureURLKey     = @"pictureURL";
NSString *const kMUUserProfileRelationshipStatusKey = @"relationshipStatus";
NSString *const KMUUserProfileAgeKey            = @"age";

#pragma mark - Photo Class

NSString *const kMUPhotoClassKey                = @"Photo";
NSString *const kMUPhotoUserKey                 = @"user";
NSString *const kMUPhotoPictureKey              = @"image";

#pragma mark - Activity Class

NSString *const kMUActivityClassKey             = @"Activity";
NSString *const kMUActivityTypeKey              = @"type";
NSString *const kMUActivityFromUserKey          = @"fromUser";
NSString *const kMUActivityToUserKey            = @"toUser";
NSString *const kMUActivityPhotoKey             = @"photo";
NSString *const kMUActivityTypeLikeKey          = @"like";
NSString *const kMUActivityTypeDislikeKey       = @"dislike";

#pragma mark - Settings

NSString *const kMUMenEnabledKey                = @"men";
NSString *const kMUWomenEnabledKey              = @"women";
NSString *const kMUSingleEnabledKey             = @"single";
NSString *const kMUAgeMaxKey                    = @"ageMax";


@end
