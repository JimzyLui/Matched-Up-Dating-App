//
//  MUChatVC.m
//  MatchedUp
//
//  Created by Jimzy Lui on 12/16/2013.
//  Copyright (c) 2013 Jimzy Lui. All rights reserved.
//

#import "MUChatVC.h"

@interface MUChatVC ()

@property(strong,nonatomic)PFUser *withUser;
@property(strong,nonatomic)PFUser *currentUser;

@property(strong,nonatomic)NSTimer *chatsTimer;
@property(nonatomic)BOOL initialLoadComplete;

@property(strong,nonatomic)NSMutableArray *chats;

@end

@implementation MUChatVC

#pragma mark - Lazy Instantiation
-(NSMutableArray *)chats
{
    if (!_chats) {
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.delegate = self;   //moving the delegate & datasource statements above the super call changes the functionality from ios6 to iOS7.
    self.dataSource = self;

    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    //[[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    [[JSBubbleView appearance] setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.currentUser = [PFUser currentUser];
    PFUser *testUser1 = self.chatRoom[kMUChatRoomUser1Key];
    
    if ([testUser1.objectId isEqual:self.currentUser.objectId]){
        self.withUser = self.chatRoom[kMUChatRoomUser2Key];
    }
    else {
        self.withUser = self.chatRoom[kMUChatRoomUser2Key];
    }
    
    self.title = self.withUser[kMUUserProfileKey][kMUUserProfileFirstNameKey];
    self.initialLoadComplete = NO;
    
    [self checkForNewChats];
    
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.chatsTimer invalidate];
    self.chatsTimer = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count];
}

#pragma mark - TableView Delegate REQUIRED

-(void)didSendText:(NSString *)text
{
    if (text.length != 0) {
        PFObject *chat = [PFObject objectWithClassName:kMUChatClassKey];
        [chat setObject:self.chatRoom forKey:kMUChatChatRoomKey];
        [chat setObject:self.currentUser forKey:kMUChatFromUserKey];
        [chat setObject:self.withUser forKey:kMUChatToUserKey];
        [chat setObject:text forKey:kMUChatTextKey];
        [chat
          saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
              [self.chats addObject:chat];
              [JSMessageSoundEffect playMessageSentSound];
              [self.tableView reloadData];
              [self finishSend];
              [self scrollToBottomAnimated:YES];
          }];
    }
}

-(JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[kMUChatFromUserKey];
    
    if ([testFromUser.objectId isEqual:self.currentUser.objectId]) {
        return JSBubbleMessageTypeOutgoing;
    }
    else{
        return JSBubbleMessageTypeIncoming;
    }
}

-(UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[kMUChatFromUserKey];
    
    if ([testFromUser.objectId isEqual:self.currentUser.objectId]) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    }
    else{
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}

-(JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyAll;
}

-(JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyNone;
}

-(JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyNone;
}

-(JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;  // for iOS 7 only, else use classic style
}


#pragma mark - Messages View Delegate OPTIONAL

-(void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
}

-(BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;  //so user retains control
}

#pragma mark - Messages View Delegate REQUIRED

-(NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    NSString *message = chat[kMUChatTextKey];
    return message;
}

-(NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Helper Methods

-(void)checkForNewChats
{
    int oldChatCount = (int)[self.chats count];
    
    PFQuery *queryForChats = [PFQuery queryWithClassName:kMUChatClassKey];
    [queryForChats whereKey:kMUChatChatRoomKey equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (self.initialLoadComplete == NO || oldChatCount != [objects count]) {
                self.chats = [objects mutableCopy];
                [self.tableView reloadData];
                
                if (self.initialLoadComplete == YES) {
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                
                self.initialLoadComplete = YES;
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}




@end
