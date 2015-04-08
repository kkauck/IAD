//
//  GameKitHelper.m
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-27.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "GameKitHelper.h"
@interface GameKitHelper()<GKGameCenterControllerDelegate>
@end

@implementation GameKitHelper

NSString *const PresentAuthenticatedView = @"present_authenticated_view";

+(instancetype)sharedHelper{
    
    static GameKitHelper *sharedHelper;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedHelper = [[GameKitHelper alloc] init];
        
    });
    
    return sharedHelper;
    
}

bool _enableGameCenter;

-(id)init{
    
    self = [super init];
    
    if (self){
        
        _enableGameCenter = YES;
        
    }
    
    return self;
    
}

//This will authenticate the current player
-(void)authenticatePlayer{
    
    GKLocalPlayer *currentPlayer = [GKLocalPlayer localPlayer];
    currentPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        
        [self setCurrentError:error];
        
        if (viewController != nil){
            
            [self setAuthenticateView:viewController];
            
        } else if ([GKLocalPlayer localPlayer].isAuthenticated){
            
            _enableGameCenter = YES;
            
        } else {
            
            _enableGameCenter = NO;
            
        }
        
    };
    
}

//Shows the Game Kit view
-(void)setAuthenticateView:(UIViewController *)authenticateView{
    
    if (authenticateView != nil){
        
        _authenticateView = authenticateView;
        [[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticatedView object:self];
        
    }
    
}

//DIsplays what the current error is
-(void)setCurrentError:(NSError *)error{
    
    _lastError = [error copy];
    
    if (_lastError){
        
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo] description]);
        
    }
    
}

//Will send the achievement notification to Game Center
-(void)sendAchievements:(NSArray *)achievements{
    
    if (!_enableGameCenter){
        
        NSLog(@"Local Player Is Not Authenticated");
        
    }
    
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        
        [self setCurrentError:error];
        
    }];
    
}

//This method is used to display the Game Center View Controller
-(void)showGameCenter:(UIViewController *)viewController{
    
    if (!_enableGameCenter){
        
        NSLog(@"Local play is not authenticated");
        
    }
    
    GKGameCenterViewController *gameCenterView = [[GKGameCenterViewController alloc] init];
    
    gameCenterView.gameCenterDelegate = self;
    gameCenterView.viewState = GKGameCenterViewControllerStateAchievements;
    
    [viewController presentViewController:gameCenterView animated:YES completion:nil];
    
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    
}

//This method will report the highest coin total to the Leaderboard
-(void)reportCoins:(int64_t)coinsForLeaderboard :(NSString *)leaderboardId{
    
    if (!_enableGameCenter){
        
        NSLog(@"Local play is not authenticated");
        
    }
    
    GKScore *coinReport = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardId];
    coinReport.value = coinsForLeaderboard;
    coinReport.context = 0;
    
    NSArray *coins = @[coinReport];
    
    [GKScore reportScores:coins withCompletionHandler:^(NSError *error) {
        
        [self setCurrentError:error];
        
    }];
    
}

@end
