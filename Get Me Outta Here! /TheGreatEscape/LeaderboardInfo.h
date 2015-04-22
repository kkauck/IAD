//
//  leaderboardInfo.h
//  GetMeOuttaHere!
//
//  Created by Kyle Kauck on 2015-04-19.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaderboardInfo : NSObject <NSCoding>

@property (nonatomic) NSNumber *coinsForBoard;
@property (nonatomic, strong) NSString *nameForBoard;

@end
