//
//  LocalLB.m
//  GetMeOuttaHere!
//
//  Created by Kyle Kauck on 2015-04-20.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "LocalLB.h"
#import "TitleScreen.h"
#import "LeaderboardInfo.h"
@import Social;

@interface LocalLB () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *leaderTable;
@property (nonatomic) UISegmentedControl *filterHighLow;
@property (nonatomic) NSMutableArray *savedLeaderboard;
@property (nonatomic) NSArray *sortedScores;
@property (nonatomic) LeaderboardInfo *currentScore;

@end

@implementation LocalLB

//UI Constants
static NSString *fontName = @"GrutchShaded";
static const int margins = 20;

- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.dynamic = NO;
    
    _leaderTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.frame.size.width, 225)];
    _leaderTable.delegate = self;
    _leaderTable.dataSource = self;
    [self.view addSubview:_leaderTable];
    
    /*_searchFilter = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 40)];
    _searchFilter.delegate = self;
    _searchFilter.placeholder = @"Filter Leaderboards Here";
    [self.view addSubview:_searchFilter];*/
    
    _filterHighLow = [[UISegmentedControl alloc] initWithItems:@[@"Highest To Lowest Scores", @"Lowest To Highest Scores"]];
    _filterHighLow.frame = CGRectMake(0, 110, self.frame.size.width, 40);
    _filterHighLow.selectedSegmentIndex = 0;
    [_filterHighLow addTarget:self action:@selector(checkHighLow: ) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_filterHighLow];

    
    [self addBackground];
    [self addBack];
    [self addLeader];
    [self addShare];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"leaderboard"];
    _savedLeaderboard = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (_savedLeaderboard == nil){
        
        _savedLeaderboard = [[NSMutableArray alloc] init];
        
    } else {
        
        _sortedScores = [_savedLeaderboard sortedArrayUsingComparator:^NSComparisonResult(LeaderboardInfo *scoreOne, LeaderboardInfo *scoreTwo) {
            
            return [scoreTwo.coinsForBoard compare:scoreOne.coinsForBoard];
            
        }];
        
    }
    
    [_leaderTable reloadData];
    
    NSLog(@"%f", self.frame.size.height);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKSpriteNode *touched = (SKSpriteNode *)[self nodeAtPoint:position];
    
    if ([touched.name isEqualToString:@"return"]){
        
        [_leaderTable removeFromSuperview];
        [_filterHighLow removeFromSuperview];
        TitleScreen *mainMenu = [TitleScreen sceneWithSize:self.frame.size];
        SKTransition *gameTransition = [SKTransition fadeWithDuration:1.5];
        [self.view presentScene:mainMenu transition:gameTransition];
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [_sortedScores count];
    
    return [_sortedScores count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"LBCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    
    _currentScore = [_sortedScores objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Name: %@", _currentScore.nameForBoard];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score: %@", _currentScore.coinsForBoard];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _currentScore = [_sortedScores objectAtIndex:indexPath.row];
    
    SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    tweet.completionHandler = ^(SLComposeViewControllerResult result){
        
        switch(result){
                
            case SLComposeViewControllerResultCancelled:
                break;
                
            case SLComposeViewControllerResultDone:{
                
                UIAlertView *nameAlert = [[UIAlertView alloc] initWithTitle:@"Successfully Tweeted!" message:@"Your Tweet Has Successfully Been Posted" delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles: nil];
                [nameAlert show];
                
                break;
                
            }
                
        }
        
    };
    
    [tweet setInitialText:[NSString stringWithFormat:@"%@ Collected %@ Coins In Get Me Outta Here!",  _currentScore.nameForBoard, _currentScore.coinsForBoard]];
    
    UIViewController *tweetView = self.view.window.rootViewController;
    [tweetView presentViewController:tweet animated:YES completion:nil];

}

-(void)checkHighLow:(UISegmentedControl *)segment{
    
    if (segment.selectedSegmentIndex == 0){
        
        _sortedScores = [_savedLeaderboard sortedArrayUsingComparator:^NSComparisonResult(LeaderboardInfo *scoreOne, LeaderboardInfo *scoreTwo) {
            
            return [scoreTwo.coinsForBoard compare:scoreOne.coinsForBoard];
            
        }];
        
        [_leaderTable reloadData];
        
    } else if (segment.selectedSegmentIndex == 1){
        
        _sortedScores = [_savedLeaderboard sortedArrayUsingComparator:^NSComparisonResult(LeaderboardInfo *scoreOne, LeaderboardInfo *scoreTwo) {
            
            return [scoreOne.coinsForBoard compare:scoreTwo.coinsForBoard];
            
        }];
        
        [_leaderTable reloadData];
        
    }
    
}

-(void)addBack{
    
    SKLabelNode *back = [[SKLabelNode alloc] initWithFontNamed:fontName];
    back.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    back.position = CGPointMake(self.size.width / 2, self.size.height - margins - 20);
    back.fontSize = 24;
    back.text = @"RETURN TO TITLE SCREEN";
    back.name = @"return";
    back.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:back];
    
}

-(void)addLeader{
    
    SKLabelNode *leader = [[SKLabelNode alloc] initWithFontNamed:fontName];
    leader.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    leader.position = CGPointMake(self.size.width / 2, self.size.height - 10);
    leader.fontSize = 24;
    leader.text = @"LOCAL LEADERBOARDS";
    leader.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:leader];
    
}

-(void)addShare{
    
    SKLabelNode *share = [[SKLabelNode alloc] initWithFontNamed:fontName];
    share.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    share.position = CGPointMake(self.size.width / 2, self.size.height - margins - 60);
    share.fontSize = 24;
    share.text = @"CLICK A HIGH SCORE TO SHARE TO TWITTER";
    share.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:share];
    
}

-(void)addBackground{
    
    SKTextureAtlas *backgroundAtlas = [self textureAtlas:@"sprites"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[backgroundAtlas textureNamed:@"titlescreen"]];
    
    background.name = @"titlescreen";
    background.position = CGPointMake(0, 0);
    background.anchorPoint = CGPointZero;
    background.size = self.size;
    
    [self addChild:background];
    
}

-(SKTextureAtlas *)textureAtlas:(NSString *)file{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        file = [NSString stringWithFormat:@"%@-iPhone", file];
        
    }
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:file];
    
    return atlas;
    
}

@end
