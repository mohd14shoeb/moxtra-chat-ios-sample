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

@interface ViewController ()<MXClientChatDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithTitle:@"APIs" style:UIBarButtonItemStylePlain target:self action:@selector(MXSDKAPISelect:)],
                                              nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
