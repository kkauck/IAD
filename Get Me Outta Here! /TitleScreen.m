//
//  TitleScreen.m
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-23.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "TitleScreen.h"
#import "GameScene.h"
#import "Instructions.h"
#import "Credits.h"
#import "GameKitHelper.h"
@import iAd;
#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_ESPSILON)

@interface TitleScreen () <ADBannerViewDelegate>

@property (nonatomic, strong) ADBannerView *ads;
@property (nonatomic) BOOL adVisible;

@end

@implementation TitleScreen

//UI Constants
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

    [self addBackground];
    [self addPlay];
    [self addInstructions];
    [self addTopTitle];
    [self addCredits];
    [self addGameCenter];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKSpriteNode *touched = (SKSpriteNode *)[self nodeAtPoint:position];
    
    if ([touched.name isEqualToString:@"playgame"]){
        
        GameScene *playGame = [GameScene sceneWithSize:self.frame.size];
        SKTransition *gameTransition = [SKTransition fadeWithDuration:2.0];
        [self.view presentScene:playGame transition:gameTransition];
        _ads.delegate = nil;
        [_ads removeFromSuperview];
        
    } else if ([touched.name isEqualToString:@"instructions"]){
        
        Instructions *instructions = [Instructions sceneWithSize:self.frame.size];
        SKTransition *instructionsTransition = [SKTransition fadeWithDuration:1.5];
        [self.view presentScene:instructions transition:instructionsTransition];
        _ads.delegate = nil;
        [_ads removeFromSuperview];
        
    } else if ([touched.name isEqualToString:@"credits"]){
        
        Credits *credits = [Credits sceneWithSize:self.frame.size];
        SKTransition *creditsTransition = [SKTransition fadeWithDuration:1.5];
        [self.view presentScene:credits transition:creditsTransition];
        _ads.delegate = nil;
        [_ads removeFromSuperview];
        
    } else if ([touched.name isEqualToString:@"gamecenter"]){
        
        UIViewController *viewController = self.view.window.rootViewController;
        
        [[GameKitHelper sharedHelper] showGameCenter:viewController];
        
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
    topTitle.position = CGPointMake(self.size.width / 2, self.size.height - 40);
    topTitle.text = @"GET ME OUTTA HERE!";
    topTitle.name = @"playgame";
    topTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:topTitle];
    
}

-(void)addPlay{
    
    SKLabelNode *play = [[SKLabelNode alloc] initWithFontNamed:fontName];
    play.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    play.position = CGPointMake(self.size.width * 0.25, self.size.height / 2 + margins);
    play.fontSize = 24;
    play.text = @"PLAY GAME";
    play.name = @"playgame";
    play.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:play];
    
}

-(void)addInstructions{
    
    SKLabelNode *instructions = [[SKLabelNode alloc] initWithFontNamed:fontName];
    instructions.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    instructions.position = CGPointMake(self.size.width * 0.75, self.size.height / 2 + margins);
    instructions.fontSize = 24;
    instructions.text = @"INSTRUCTIONS";
    instructions.name = @"instructions";
    instructions.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:instructions];
    
}

-(void)addCredits{
    
    SKLabelNode *credits = [[SKLabelNode alloc] initWithFontNamed:fontName];
    credits.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    credits.position = CGPointMake(self.size.width * 0.25, self.size.height / 2 - margins);
    credits.fontSize = 24;
    credits.text = @"CREDITS";
    credits.name = @"credits";
    credits.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:credits];
    
}

-(void)addGameCenter{
    
    SKLabelNode *gamecenter = [[SKLabelNode alloc] initWithFontNamed:fontName];
    gamecenter.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    gamecenter.position = CGPointMake(self.size.width * 0.75, self.size.height / 2 - margins);
    gamecenter.fontSize = 24;
    gamecenter.text = @"GAME CENTER";
    gamecenter.name = @"gamecenter";
    gamecenter.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:gamecenter];
    
}

#pragma mark Helper Class
//This is called to figure out which texture atlas needs to be used to get the correct images for the game depending on the device, either iPad or iPhone.
-(SKTextureAtlas *)textureAtlas:(NSString *)file{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        file = [NSString stringWithFormat:@"%@-iPhone", file];
        
    }
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:file];
    
    return atlas;
    
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