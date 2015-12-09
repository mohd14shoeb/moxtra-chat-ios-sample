//
//  ViewController.m
//  MoxieChat
//
//  Created by Ken Yu on 12/7/15.
//  Copyright © 2015 Ken Yu. All rights reserved.
//

#import "ViewController.h"
#import "Moxtra.h"

#define MOXTRASDK_TEST_USER1_UniqueID       JohnDoe         //dummy user1
#define MOXTRASDK_TEST_USER2_UniqueID       KevinRichardson //dummy user2

@interface ViewController ()<MXClientChatDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSMutableArray *chatList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithTitle:@"APIs" style:UIBarButtonItemStylePlain target:self action:@selector(MXSDKAPISelect:)],
                                              nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
}

- (void)MXSDKAPISelect:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf initializeMoxtraAccount];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Unlink Account" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf unlinkMoxtraAccount];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Fetch Chat List" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf fetchChatList];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"New Chat" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf startNewChat];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)initializeMoxtraAccount
{
    // Initialize user using unique user identity
    MXUserIdentity *useridentity = [[MXUserIdentity alloc] init];
    useridentity.userIdentityType = kUserIdentityTypeIdentityUniqueID;
    useridentity.userIdentity = @"JohnDoe";
    
    [[Moxtra sharedClient] initializeUserAccount: useridentity orgID: nil firstName: @"John" lastName: @"Doe" avatar: nil devicePushNotificationToken: nil withTimeout:0.0 success: ^{
        
        NSLog(@"Initialize user successfully");
    } failure: ^(NSError *error) {
        
        if (error.code == MXClientErrorUserAccountAlreadyExist)
            NSLog(@"There is a user exist, if you want to initialize with another user please unlink current user firstly");
        
        NSLog(@"Initialize user failed, %@", [NSString stringWithFormat:@"error code [%ld] description: [%@] info [%@]", (long)[error code], [error localizedDescription], [[error userInfo] description]]);
    }];
    
    // Set delegate
    [Moxtra sharedClient].delegate = self;
}

- (void)unlinkMoxtraAccount
{
    [[Moxtra sharedClient] unlinkAccount:^(BOOL success) {
        
        if (success)
            NSLog(@"Unlink user successfully");
        else
            NSLog(@"Unlink user failed");
    }];
}

- (void)fetchChatList
{
    NSArray *chatListArray = [[Moxtra sharedClient] getChatSessionArray];
    self.chatList = [NSMutableArray arrayWithArray:chatListArray];
    [self.tableView reloadData];
}

- (void)startNewChat
{
	static NSDateFormatter *dateFormatter = nil;
    if( dateFormatter == nil )
    {
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-YYYY HH:mm:ss.SSS"];
    }
    NSString *datetimestr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *topic = [NSString stringWithFormat:@"chat-%@", datetimestr];
    __weak typeof(self) weakSelf = self;
    [[Moxtra sharedClient] createChat:topic inviteMembersUniqueID:nil success:^(NSString *binderID, UIViewController *chatViewController) {
        
        NSLog(@"Start a new chat successfully");
        if (chatViewController)
        {
            [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
            [weakSelf.navigationController pushViewController:chatViewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"Start a new chat failed, %@", [NSString stringWithFormat:@"error code [%ld] description: [%@] info [%@]", (long)[error code], [error localizedDescription], [[error userInfo] description]]);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.chatList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"MXChatListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    MXChatSession *chatGroup = [self.chatList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",chatGroup.topic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MXChatSession *chat = [self.chatList objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    [[Moxtra sharedClient] getChatViewController:chat.binderID success:^(UIViewController *chatViewController) {
        
        NSLog(@"open a chat successfully");
        if (chatViewController)
        {
            [weakSelf.navigationController setNavigationBarHidden:YES animated:NO];
            [weakSelf.navigationController pushViewController:chatViewController animated:YES];
        }
    } failure:^(NSError *error) {
    
        NSLog(@"open a chat failed, %@", [NSString stringWithFormat:@"error code [%ld] description: [%@] info [%@]", (long)[error code], [error localizedDescription], [[error userInfo] description]]);
    }];
}


#pragma mark - MXClientChatDelegate
- (void)onChatSessionUpdated:(MXChatSession*)chatSession;
{
    if (chatSession)
    {
        [self.tableView reloadData];
    }
}

- (void)onChatSessionCreated:(MXChatSession*)chatSession;
{
    if (chatSession)
    {
        [self.chatList addObject:chatSession];
        [self.tableView reloadData];
    }
}
- (void)onChatSessionDeleted:(MXChatSession*)chatSession;
{
    if (chatSession)
    {
        [self.chatList removeObject:chatSession];
        [self.tableView reloadData];
    }
}

- (void)popChatViewController:(UIViewController*)chatViewController isDeleted:(BOOL)isDeleted;
{
    [chatViewController.navigationController setNavigationBarHidden:NO animated:NO];
    
    if (chatViewController)
        [chatViewController.navigationController popViewControllerAnimated:YES];
}
@end
