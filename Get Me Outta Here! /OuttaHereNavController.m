//
//  OuttaHereNavController.m
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-27.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "OuttaHereNavController.h"
#import "GameKitHelper.h"
@import GameKit;

@interface OuttaHereNavController ()

@end

@implementation OuttaHereNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticatorView) name:PresentAuthenticatedView object:nil];
    
    [[GameKitHelper sharedHelper] authenticatePlayer];
    
}

-(void)showAuthenticatorView{
    
    GameKitHelper *kitHelper = [GameKitHelper sharedHelper];
    
    [self.topViewController presentViewController:kitHelper.authenticateView animated:YES completion:nil];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
