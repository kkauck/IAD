//
//  GameOver.m
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-23.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"
#import "Instructions.h"
#import "TitleScreen.h"
#import "Credits.h"
@import iAd;
#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_ESPSILON)
@import AVFoundation;

@interface GameOver () <ADBannerViewDelegate>

//Setting Up Needed Properties for Game Over Scene
@property (nonatomic) AVAudioPlayer *musicPlayer;
@property (nonatomic, strong) ADBannerView *ads;
@property (nonatomic) BOOL adVisible;

@end

@implementation GameOver
@synthesize coinsCollected;

static NSString *fontName = @"GrutchShaded";
static const int margins = 20;

#pragma mark Screen Setup
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.dynamic = NO;
    
    _ads = [[ADBannerView alloc] initWithFrame:CGRectZero];
    self.ads.delegate = self;
    [_ads setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 350)];
    
    [self playMusic:@"gameover.caf"];
    
    [self addBackground];
    [self addPlay];
    [self addGameover];
    [self addCoinTotal];
    [self addTopTitle];
    [self addMainMenu];
    [self addHighScore];
    
    if (coinsCollected >= [self highScore]){
        
        [[NSUserDefaults standardUserDefaults] setInteger:coinsCollected forKey:@"highscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKSpriteNode *touched = (SKSpriteNode *)[self nodeAtPoint:position];
    
    if ([touched.name isEqualToString:@"playgame"]){
        
        [_musicPlayer stop];
        
        GameScene *playGame = [GameScene sceneWithSize:self.frame.size];
        SKTransition *gameTransition = [SKTransition fadeWithDuration:2.0];
        [self.view presentScene:playGame transition:gameTransition];
        
        _ads.delegate = nil;
        [_ads removeFromSuperview];
        
    } else if ([touched.name isEqualToString:@"mainmenu"]){
        
        [_musicPlayer stop];
        
        TitleScreen *mainMenu = [TitleScreen sceneWithSize:self.frame.size];
        SKTransition *gameTransition = [SKTransition fadeWithDuration:1.5];
        [self.view presentScene:mainMenu transition:gameTransition];
        
        _ads.delegate = nil;
        [_ads removeFromSuperview];
        
    }
    
}

#pragma mark Adding Backround/Lables
-(void)addBackground{
    
    SKTextureAtlas *backgroundAtlas = [self textureAtlas:@"sprites"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[backgroundAtlas textureNamed:@"titlescreen"]];
    
    background.name = @"titlescreen";
    background.position = CGPointMake(0, 0);
    background.anchorPoint = CGPointZero;
    background.size = self.size;
    
    [self addChild:background];
    
}

-(void)addTopTitle{
    
    SKLabelNode *topTitle = [[SKLabelNode alloc] initWithFontNamed:fontName];
    topTitle.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    topTitle.fontSize = 40;
    topTitle.position = CGPointMake(self.size.width / 2, self.size.height - margins);
    topTitle.text = @"GET ME OUTTA HERE!";
    topTitle.name = @"title";
    topTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:topTitle];
    
}

-(void)addPlay{
    
    SKLabelNode *play = [[SKLabelNode alloc] initWithFontNamed:fontName];
    play.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    play.position = CGPointMake(self.size.width * 0.75, self.size.height / 2 + margins);
    play.fontSize = 24;
    play.text = @"PLAY AGAIN";
    play.name = @"playgame";
    play.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:play];
    
}

-(void)addMainMenu{
    
    SKLabelNode *mainMenu = [[SKLabelNode alloc] initWithFontNamed:fontName];
    mainMenu.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    mainMenu.position = CGPointMake(self.size.width * 0.25, self.size.height / 2 + margins);
    mainMenu.fontSize = 24;
    mainMenu.text = @"MAIN MENU";
    mainMenu.name = @"mainmenu";
    mainMenu.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:mainMenu];
    
}

-(void)addGameover{
    
    SKLabelNode *gameover = [[SKLabelNode alloc] initWithFontNamed:fontName];
    gameover.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    gameover.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 110);
    gameover.text = @"GAME OVER!";
    gameover.fontSize = 32;
    gameover.name = @"gameover";
    gameover.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:gameover];
    
}

-(void)addCoinTotal{
    
    SKLabelNode *coins = [[SKLabelNode alloc] initWithFontNamed:fontName];
    coins.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    coins.position = CGPointMake(self.size.width * 0.25, self.size.height / 2 - margins);
    coins.text = [NSString stringWithFormat:@"You Collected: %lu Coins!", (unsigned long)coinsCollected];
    coins.name = @"coins";
    coins.fontSize = 20;
    coins.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:coins];
    
}

-(void)addHighScore{
    
    SKLabelNode *highScore = [[SKLabelNode alloc] initWithFontNamed:fontName];
    highScore.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    highScore.position = CGPointMake(self.size.width * 0.75, self.size.height / 2 - margins);
    highScore.text = [NSString stringWithFormat:@"High Score: %lu Coins!", (unsigned long)[self highScore]];
    highScore.name = @"highscore";
    highScore.fontSize = 20;
    highScore.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:highScore];
    
}

#pragma mark Helper Class
//This method is used to setup the music player to be able to play the background music for the game.
-(void)playMusic:(NSString *)file{
    
    NSError *error;
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:file withExtension:nil];
    
    _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
    _musicPlayer.numberOfLoops = -1;
    
    [_musicPlayer prepareToPlay];
    [_musicPlayer play];
    
}

//This is called to figure out which texture atlas needs to be used to get the correct images for the game depending on the device, either iPad or iPhone.
-(SKTextureAtlas *)textureAtlas:(NSString *)file{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        file = [NSString stringWithFormat:@"%@-iPhone", file];
        
    }
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:file];
    
    return atlas;
    
}

-(NSInteger)highScore{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    
}

//These methods are used for both loading and failing to load ads
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
    if (!_adVisible){
        
        if (_ads.superview == nil){
            
            [self.view addSubview:_ads];
            
        }
        
        [UIView beginAnimations:@"animateAdBannerShow" context:NULL];
        _ads.frame = CGRectOffset(_ads.frame, 0, -_ads.frame.size.height);
        
        [UIView commitAnimations];
        
        _adVisible = YES;
        
    }
    
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
    NSLog(@"Failed to load an Ad!");
    
    if (_adVisible){
        
        [UIView beginAnimations:@"animateAdBannerHide" context:NULL];
        _ads.frame = CGRectOffset(_ads.frame, 0, _ads.frame.size.height);
        
        [UIView commitAnimations];
        
        _adVisible = NO;
        
    }
    
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    
    _ads.delegate = nil;
    [_ads removeFromSuperview];
    
}

@end
