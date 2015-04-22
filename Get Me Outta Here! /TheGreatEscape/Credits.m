//
//  Credits.m
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-23.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "Credits.h"
#import "GameScene.h"
#import "TitleScreen.h"
#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_ESPSILON)

@implementation Credits

static NSString *fontName = @"GrutchShaded";
static const int margins = 20;

#pragma mark Screen Setup
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.dynamic = NO;
    
    [self addBackground];
    [self addCreatorText];
    [self addStartGame];
    [self addMusicText];
    [self addImagesText];
    [self addSoundsText];
    [self addBattleText];
    [self addGameoverText];
    [self addCoinText];
    [self addTopTitle];
    [self addMainMenu];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKSpriteNode *touched = (SKSpriteNode *)[self nodeAtPoint:position];
    
    if ([touched.name isEqualToString:@"playgame"]){
        
        GameScene *playGame = [GameScene sceneWithSize:self.frame.size];
        SKTransition *gameTransition = [SKTransition fadeWithDuration:1.0];
        [self.view presentScene:playGame transition:gameTransition];
        
    } else if ([touched.name isEqualToString:@"mainmenu"]){
        
        TitleScreen *mainMenu = [TitleScreen sceneWithSize:self.frame.size];
        SKTransition *gameTransition = [SKTransition fadeWithDuration:1.5];
        [self.view presentScene:mainMenu transition:gameTransition];
        
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
    topTitle.name = @"playgame";
    topTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:topTitle];
    
}

-(void)addCreatorText{
    
    SKLabelNode *creatorText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    creatorText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    creatorText.fontSize = 16;
    creatorText.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 110);
    creatorText.text = @"THE GREAT ESCAPE CREATOR: Kyle Kauck";
    creatorText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:creatorText];
    
}

-(void)addImagesText{
    
    SKLabelNode *imageText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    imageText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    imageText.fontSize = 16;
    imageText.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 95);
    imageText.text = @"Images From: www.kenney.nl";
    imageText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:imageText];
    
}

-(void)addMusicText{
    
    SKLabelNode *musicText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    musicText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    musicText.fontSize = 16;
    musicText.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 80);
    musicText.text = @"Jump Sound: User dklon on OpenGameArt.org";
    musicText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:musicText];
    
}

-(void)addBattleText{
    
    SKLabelNode *battleText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    battleText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    battleText.fontSize = 16;
    battleText.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 65);
    battleText.text = @"Battle In The Winter(Gameplay Music): Johan Brodd - OpenGameArt.org";
    battleText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:battleText];
    
}

-(void)addSoundsText{
    
    SKLabelNode *soundsText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    soundsText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    soundsText.fontSize = 16;
    soundsText.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 35);
    soundsText.text = @"Snow Shoe Step: Corsica_S - OpenGameArt.org";
    soundsText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:soundsText];
    
}

-(void)addGameoverText{
    
    SKLabelNode *gameoverText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    gameoverText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    gameoverText.fontSize = 16;
    gameoverText.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 50);
    gameoverText.text = @"The End (Death Screen Mix): User Avgvsta on OpenGameArt.org";
    gameoverText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:gameoverText];
    
}

-(void)addCoinText{
    
    SKLabelNode *coinText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    coinText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    coinText.fontSize = 16;
    coinText.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 20);
    coinText.text = @"Coin Sound: User Luke.RUSTLTD on OpenGameArt.org";
    coinText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:coinText];
    
}

-(void)addStartGame{
    
    SKLabelNode *startGame = [[SKLabelNode alloc] initWithFontNamed:fontName];
    startGame.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    startGame.position = CGPointMake(self.size.width * 0.75, self.size.height / 2 - margins);
    startGame.fontSize = 24;
    startGame.text = @"PLAY GAME";
    startGame.name = @"playgame";
    startGame.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:startGame];
    
}

-(void)addMainMenu{
    
    SKLabelNode *mainMenu = [[SKLabelNode alloc] initWithFontNamed:fontName];
    mainMenu.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    mainMenu.position = CGPointMake(self.size.width * 0.25, self.size.height / 2 - margins);
    mainMenu.fontSize = 24;
    mainMenu.text = @"MAIN MENU";
    mainMenu.name = @"mainmenu";
    mainMenu.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:mainMenu];
    
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

@end
