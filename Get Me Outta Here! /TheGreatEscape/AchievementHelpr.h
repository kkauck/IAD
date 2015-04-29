//
//  AchievementHelpr.h
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-28.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

@interface AchievementHelpr : NSObject

+(GKAchievement *)coinsCollected:(NSUInteger)coinsCollected;
+(GKAchievement *)beeTouched:(BOOL)beeTouched;

@end
