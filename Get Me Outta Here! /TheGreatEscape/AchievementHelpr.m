//
//  AchievementHelpr.m
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-28.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "AchievementHelpr.h"

static NSString* const coinCollectedAchievementId = @"com.wwdstudios.GetMeOuttaHere.collectedacoin";
static NSString* const twentyFiveCoinsCollectedAchievementId = @"com.wwdstudios.GetMeOuttaHere.collected25coins";
static NSString* const fiftyCoinsCollectedAchievementId = @"com.wwdstudios.GetMeOuttaHere.collected50coins";
static NSString* const oneHundredCoinsCollectedAchievementId = @"com.wwdstudios.GetMeOuttaHere.collected100coins";
static NSString* const twoHundredFiftyCoinsCollectedAchievementId = @"com.wwdstudios.GetMeOuttaHere.collected250coins";
static NSString* const coinMaster = @"com.wwdstudios.GetMeOuttaHere.coinmaster";
static NSString* const touchedBee = @"com.wwdstudios.GetMeOuttaHere.touched";

static const NSInteger maxCoins = 250;

@implementation AchievementHelpr

+(GKAchievement *)coinsCollected:(NSUInteger)coinCollected{
    
    CGFloat percentComplete = (coinCollected/maxCoins) * 100;
    NSString *achieveId = @"";
    
    if (coinCollected == 1){
        
        achieveId = coinCollectedAchievementId;
        percentComplete = 100;
        
    } else if (coinCollected == 25){
        
        achieveId = twentyFiveCoinsCollectedAchievementId;
        percentComplete = 100;
        
    } else if (coinCollected == 50){
        
        achieveId = fiftyCoinsCollectedAchievementId;
        percentComplete = 100;
        
    } else if (coinCollected == 100){
        
        achieveId = oneHundredCoinsCollectedAchievementId;
        percentComplete = 100;
        
    } else if (coinCollected == 250){
        
        achieveId = twoHundredFiftyCoinsCollectedAchievementId;
        percentComplete = 100;
        
    } else if (coinCollected == 500){
        
        achieveId = coinMaster;
        percentComplete = 100;
        
    }
    
    GKAchievement *coinsAchievement= [[GKAchievement alloc] initWithIdentifier:achieveId];
    
    coinsAchievement.percentComplete = percentComplete;
    coinsAchievement.showsCompletionBanner = YES;
    return coinsAchievement;
    
}

+(GKAchievement *)beeTouched:(BOOL)beeTouched{
    
    NSString *achieveId = @"";
    CGFloat percentComplete = 100;
    
    if (beeTouched == YES){
        
        achieveId = touchedBee;
        
    }
    
    
    GKAchievement *beeAchievement= [[GKAchievement alloc] initWithIdentifier:achieveId];
    
    beeAchievement.percentComplete = percentComplete;
    beeAchievement.showsCompletionBanner = YES;
    return beeAchievement;
    
}

@end
