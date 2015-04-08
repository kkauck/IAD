//
//  Instructions.m
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-23.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//

#import "Instructions.h"
#import "GameScene.h"
#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_ESPSILON)

@implementation Instructions

static NSString *fontName = @"GrutchShaded";
static const int margins = 20;

#pragma mark Screen Setup
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.dynamic = NO;
    
    [self addBackground];
    [self addInstructions];
    [self addTouch];
    [self addInstructionsText];
    [self addStartGame];
    [self addTopTitle];
    [self addInstructionsPartTwo];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    GameScene *playGame = [GameScene sceneWithSize:self.frame.size];
    SKTransition *gameTransition = [SKTransition fadeWithDuration:2.0];//[SKTransition fadeWithDuration:1.5];
    [self.view presentScene:playGame transition:gameTransition];
    
}

#pragma mark Adding Backround/Lables
-(void)addBackground{
    
    SKTextureAtlas *backgroundAtlas = [self textureAtlas:@"sprites"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[backgroundAtlas textureNamed:@"titlescreen"]];
    
    background.name = @"titlescreen";
    background.position = CGPointMake(0, 0);
    background.anchorPoint = CGPointZero;
    
    [self addChild:background];
    
}

-(void)addInstructions{
    
    SKLabelNode *instructions = [[SKLabelNode alloc] initWithFontNamed:fontName];
    instructions.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    instructions.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 110);
    instructions.text = @"INSTRUCTIONS";
    instructions.name = @"instructions";
    instructions.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:instructions];
    
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

-(void)addTouch{
    
    SKTextureAtlas *touchAtlas = [self textureAtlas:@"sprites"];
    SKSpriteNode *touch = [SKSpriteNode spriteNodeWithTexture:[touchAtlas textureNamed:@"touch"]];
    
    touch.name = @"touch";
    touch.scale = 0.75;
    touch.position = CGPointMake(self.size.width / 2 - 10 , self.size.height / 2 + 20);
    touch.anchorPoint = CGPointZero;
    
    [self addChild:touch];
    
}

-(void)addInstructionsText{
    
    SKLabelNode *instructionsText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    instructionsText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    instructionsText.fontSize = 16;
    instructionsText.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 10);
    instructionsText.text = @"TAP THE BACKGROUND, GROUND OR CHARACTER";
    instructionsText.name = @"instructions";
    instructionsText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:instructionsText];
    
}

-(void)addInstructionsPartTwo{
    
    SKLabelNode *instructionsText = [[SKLabelNode alloc] initWithFontNamed:fontName];
    instructionsText.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    instructionsText.fontSize = 16;
    instructionsText.position = CGPointMake(self.size.width / 2, self.size.height / 2 - 5);
    instructionsText.text = @"TO JUMP OVER OBSTACLES AND COLLECT COINS!";
    instructionsText.name = @"instructions";
    instructionsText.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:instructionsText];
    
}

-(void)addStartGame{
    
    SKLabelNode *startGame = [[SKLabelNode alloc] initWithFontNamed:fontName];
    startGame.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    startGame.fontSize = 16;
    startGame.position = CGPointMake(self.size.width / 2, self.size.height / 2 - 20);
    startGame.text = @"TAP ANYWHERE TO START GAME";
    startGame.name = @"startgame";
    startGame.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [self addChild:startGame];
    
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
