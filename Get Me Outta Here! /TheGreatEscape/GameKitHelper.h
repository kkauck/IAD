//
//  GameKitHelper.h
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-27.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

extern NSString *const PresentAuthenticatedView;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticateView;
@property (nonatomic,readonly) NSError *lastError;

+(instancetype)sharedHelper;
-(void)authenticatePlayer;
-(void)sendAchievements:(NSArray *)achievements;
-(void)showGameCenter:(UIViewController *)viewController;
-(void)reportCoins:(int64_t)coinsForLeaderboard :(NSString *)leaderboardId;

@end
