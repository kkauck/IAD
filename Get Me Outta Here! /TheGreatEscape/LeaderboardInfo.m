//
//  leaderboardInfo.m
//  GetMeOuttaHere!
//
//  Created by Kyle Kauck on 2015-04-19.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "LeaderboardInfo.h"

@implementation LeaderboardInfo
@synthesize coinsForBoard, nameForBoard;

-(id)initWithCoder:(NSCoder *)code{
    
    if (self = [super init]){
        
        self.nameForBoard = [code decodeObjectForKey:@"name"];
        self.coinsForBoard = [code decodeObjectForKey:@"coins"];
        
    }
    
    return self;
    
}

-(void) encodeWithCoder:(NSCoder *)code{
    
    [code encodeObject:nameForBoard forKey:@"name"];
    [code encodeObject:coinsForBoard forKey:@"coins"];
    
}

@end
