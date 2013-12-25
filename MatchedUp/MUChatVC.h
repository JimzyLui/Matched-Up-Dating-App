//
//  MUChatVC.h
//  MatchedUp
//
//  Created by Jimzy Lui on 12/16/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface MUChatVC : JSMessagesViewController<JSMessagesViewDataSource,JSMessagesViewDelegate>

@property (strong,nonatomic)PFObject *chatRoom;

@end
