//
//  GameScene.m
//  Get Me Outta Here!
//
//  Created by Kyle Kauck on 2015-03-03.
//  Copyright (c) 2015 Kyle Kauck. All rights reserved.
//
//  Jump sound credit from OpenGameArt User dklon

#import "GameScene.h"
#import "GameOver.h"
#import "GameKitHelper.h"
#import "AchievementHelpr.h"
#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_ESPSILON)
@import AVFoundation;

@interface GameScene ()

//Properties for Sprites
@property (nonatomic) SKSpriteNode *player;
@property (nonatomic) SKSpriteNode *playerJumping;
@property (nonatomic) SKSpriteNode *playerDying;
@property (nonatomic) SKSpriteNode *coins;
@property (nonatomic) SKSpriteNode *bee;
@property (nonatomic) SKSpriteNode *ground;
@property (nonatomic) SKSpriteNode *heartOne;
@property (nonatomic) SKSpriteNode *heartTwo;
@property (nonatomic) SKSpriteNode *heartThree;
@property (nonatomic) SKSpriteNode *hearts;

//Properties for Actions
@property (nonatomic) SKAction *coinSound;
@property (nonatomic) SKAction *jumpSound;
@property (nonatomic) SKAction *deathSound;
@property (nonatomic) SKAction *walkingSound;
@property (nonatomic) SKAction *backgroundMusic;
@property (nonatomic) SKAction *playerAnimation;
@property (nonatomic) SKAction *beeAnimation;
@property (nonatomic) SKAction *walking;
@property (nonatomic) SKAction *beeMoving;

//Properties for Nodes
@property (nonatomic) SKNode *sceneNode;
@property (nonatomic) SKNode *beeNode;
@property (nonatomic) SKNode *coinNode;
@property (nonatomic) SKNode *playerNode;
@property (nonatomic) SKNode *pausePlayNode;
@property (nonatomic) SKNode *heartsUINode;

//Properties for Misc. Usage
@property (nonatomic) CGFloat floorHeight;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) NSTimeInterval updatedTime;
@property (nonatomic) NSTimeInterval lastUpdate;
@property (nonatomic) NSTimeInterval dt;
@property (nonatomic) float start;
@property (nonatomic) AVAudioPlayer *musicPlayer;
@property (nonatomic) BOOL playing;
@property (nonatomic) SKLabelNode *score;
@property (nonatomic) NSUInteger coinsCollected;

@end

//Categories for my Sprites
static const uint32_t playerCategory = 0x1;
static const uint32_t coinCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;
static const uint32_t beeCategory = 0x1 << 3;
static const uint32_t heartCategory = 0x1 <<4;

//Obstacle Spawning Times
static const float obstacleDelay = 1.0f;
static const float obstacleUpdateMinTime = 1.0f;
static const float obstableUpdateMaxTime = 2.0f;

//Coin Spawning Times
static const float coinDelay = 0.5f;
static const float coinUpdateMin = 1.5f;
static const float coinUpdateMax = 2.5f;

//Heart Spawning Times
static const float heartDelay = 3.0f;
static const float heartUpdateMin = 8.0f;
static const float heartUpdateMax = 10.0f;

//UI Constants
static NSString *fontName = @"GrutchShaded";

@implementation GameScene

#pragma mark View/Touches/Update Methods

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    //Setting Up All Needed Inforamtion/Methods
    [self setupSound];
    _playing = YES;
    _coinsCollected = 0;
    
    //Will more closely resemble the gravity of the moon to allow for funner gameplay.
    self.physicsWorld.gravity = CGVectorMake(0, -3.5);
    self.physicsWorld.contactDelegate = self;
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.dynamic = NO;
    
    [self playMusic:@"music.caf"];
    
    _sceneNode = [SKNode node];
    _beeNode = [SKNode node];
    _coinNode = [SKNode node];
    _playerNode = [SKNode node];
    _pausePlayNode = [SKNode node];
    _heartsUINode = [SKNode node];
    [self addChild:_sceneNode];
    [self addChild:_beeNode];
    [self addChild:_coinNode];
    [self addChild:_playerNode];
    [self addChild:_pausePlayNode];
    [self addChild:_heartsUINode];
    
    //This calls all of my methods on creating nodes
    [self addBackground];
    [self addPlayerWalking];
    [self startSpawningBees];
    [self startSpawningCoins];
    [self startSpawningHearts];
    [self setupScoreLabel];
    [self setupHeartOne];
    [self setupHeartTwo];
    [self setupHeartThree];
   // [_pausePlayNode addChild:[self pauseButton]];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInNode:self];
    SKSpriteNode *touched = (SKSpriteNode *)[self nodeAtPoint:position];
    
    if ([touched.name isEqualToString:@"pause"]){
        
        [self pauseGame];
        [_pausePlayNode removeAllChildren];
        [_pausePlayNode addChild:[self playButton]];
        
        
    } else if ([touched.name isEqualToString:@"walking"] || [touched.name isEqualToString:@"background"] || [touched.name isEqualToString:@"ground"]){
        
        if (_heartThree != nil){
            
            [self playerSuperJumpingAnimation];
            
        } else {
            
            [self playerJumpingAnimation];
            
        }
        
    } else if ([touched.name isEqualToString:@"play"]){
        
        [self playGame];
        [_pausePlayNode removeAllChildren];
        [_pausePlayNode addChild:[self pauseButton]];
        
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //When playing is set to true, the background/ground will be updated
    if (_playing == TRUE){
        
        [self updateBackground];
        [self updateGround];
        
    } else {
        
        //When the player hits a bee it will stop all actions for spawning and will continue to let the background scroll.
        [self stopAction];
        
    }
    
    if (_lastUpdate){
        
        _dt = currentTime - _lastUpdate;
        
    } else {
        
        _dt = 0;
        
    }
    
    _lastUpdate = currentTime;
    
}

#pragma mark Background & Foreground Methods

//These are all calls to add in the specific sprites for the game, that are called when the scene is currently made, once real development beings these will be called at specfic points in the game.
-(void) addBackground{
    
    for (int i = 0; i < 3; i++){
    
        //Creates a node, and then sets it to the image background2
        SKTextureAtlas *backgroundAtlas = [self textureAtlas:@"sprites"];
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[backgroundAtlas textureNamed:@"background"]];
        
        //This will position the background at point 0,0 and then have its anchor point also set to 0,0
        background.position = CGPointMake(i * self.size.width, 0);
        background.anchorPoint = CGPointZero;
        background.name = @"background";
        
        //This adds the node to the scene
        [_sceneNode addChild:background];
        
    }
    
    for (int i = 0; i < 3; i++){
        
        SKTextureAtlas *atlas = [self textureAtlas:@"sprites"];
        _ground = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"ground"]];
        _ground.position = CGPointMake(i * self.size.width, 0);
        _ground.anchorPoint = CGPointZero;
        _ground.name = @"ground";
        
        _ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_ground.size.width, _ground.size.height * 2)];
        _ground.physicsBody.dynamic = NO;
        _ground.physicsBody.categoryBitMask = groundCategory;
        _ground.physicsBody.collisionBitMask = 0;
        _ground.physicsBody.contactTestBitMask = playerCategory;
        
        [_sceneNode addChild:_ground];
        
    }
    
}

//These two methods allow the scrolling of both the background and the ground so it gives the sense of an endless runner.
-(void)updateGround{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [_sceneNode enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode *node, BOOL *stop) {
            
            SKSpriteNode *ground = (SKSpriteNode *) node;
            
            //The -3.5 is the speed in which the ground is moving, the ground moves quicker then the background since the closer you are the faster things appear which would mean it should look like the background is moving slowly.
            ground.position = CGPointMake(ground.position.x - 3.5, ground.position.y);
            
            if (ground.position.x < -ground.size.width){
                
                ground.position = CGPointMake(ground.position.x + ground.size.width * 2, ground.position.y);
                
            }
            
            
        }];
        
    }
    
}

-(void)updateBackground{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [_sceneNode enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
            
            SKSpriteNode *background = (SKSpriteNode *) node;
            
            //The -1 is the speed in which the background is moving, the closer to 0 the slower the backgroun moves.
            background.position = CGPointMake(background.position.x - 1, background.position.y);
            
            if (background.position.x < -background.size.width){
                
                background.position = CGPointMake(background.position.x + background.size.width * 2, background.position.y);
                
            }
            
        }];
        
    }
    
}

#pragma mark Coin Methods

-(void)addCoin {
    
    SKTextureAtlas *atlas = [self textureAtlas:@"sprites"];
    _coins = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"coin"]];
    
    //This will give the node a name so it can be used for touches.
    _coins.name = @"coins";
    
    //This will scale the node/image to the size I feel is good for the game.
    _coins.scale = 0.35;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        float randomPhoneX = [self randomNumber:900 andValue:1200];
        float randomPhoneY = [self randomNumber:100 andValue:190];
        _coins.position = CGPointMake(randomPhoneX, randomPhoneY);
        
        CGPoint location = CGPointMake(-self.frame.size.width + _coins.size.width/2, 100);
        
        SKAction *moving = [SKAction moveTo:location duration:15];
        [_coins runAction:moving withKey:@"moveCoin"];
        
    }
    
    _coins.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_coins.size.width / 3];
    _coins.physicsBody.dynamic = NO;

    //This sets the Catergoy to the coinCategory, sets it so it can be collided with and finally sets it that it should only colide with the player.
    _coins.physicsBody.categoryBitMask = coinCategory;
    _coins.physicsBody.collisionBitMask = 0;
    _coins.physicsBody.contactTestBitMask = playerCategory;
    
    [_coinNode addChild:_coins];
    
}

//This method is used to start spawning the coins through the gameplay. It setups up an initial delay for when the first coin should spawn. The next action is called to get a seclector in this case the coin method, and will call that for each spawn in the sequence. The next delay sets a random number each time for how quickly the coins should spawn. Fianlly the last three actions are used to make sequences, the first to set the spawn and delay for every coin, the next to make use those two actions forever and finally an action that sets the initial coin delay and then the spawnForever action.
-(void)startSpawningCoins{
    
    SKAction *coinDelayTime = [SKAction waitForDuration:coinDelay];
    SKAction *spawnCoin = [SKAction performSelector:@selector(addCoin) onTarget:self];
    SKAction *spawnCoinDelay = [SKAction waitForDuration:[self randomNumber:coinUpdateMin andValue:coinUpdateMax]];
    
    SKAction *coinSpawnSequence = [SKAction sequence:@[spawnCoin, spawnCoinDelay]];
    SKAction *coinSpawnForever = [SKAction repeatActionForever:coinSpawnSequence];
    SKAction *completeCoinSequence = [SKAction sequence:@[coinDelayTime, coinSpawnForever]];
    
    [self runAction:completeCoinSequence withKey:@"coinSpawn"];
    
}

#pragma mark Player Methods

//This method will create the player, with the physics body it sets the correct category for the player, and then sets which categories it should collide with, including the bees, coins and ground.
-(void)addPlayerWalking{
    
    SKTextureAtlas *atlas = [self textureAtlas:@"sprites"];
    _player = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"walking1"]];
    _player.name = @"walking";
    _player.scale = 0.55;
    _player.physicsBody.dynamic = NO;
    _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.frame.size];
    _player.physicsBody.categoryBitMask = playerCategory;
    _player.physicsBody.contactTestBitMask = beeCategory | coinCategory | groundCategory;
    _player.position = CGPointMake(self.size.width * 0.15, 100);
    _player.physicsBody.allowsRotation = NO;
    
    [_playerNode addChild:_player];
    
    //This creates a NSMutableArray for the textures used to make the player walk.
    NSMutableArray *walking = [NSMutableArray arrayWithCapacity:10];
    
    //This will make the player walk
    for (int i = 1; i < 3; i++){
        
        NSString *textureName = [NSString stringWithFormat:@"walking%d", i];
        SKTexture *textures = [SKTexture textureWithImageNamed:textureName];
        [walking addObject:textures];
        
    }
    
    //And this reverses the textures so it is a smooth motion
    for (int i = 2; i > 0; i--){
        
        NSString *textureName = [NSString stringWithFormat:@"walking%d", i];
        SKTexture *textures = [SKTexture textureWithImageNamed:textureName];
        [walking addObject:textures];
        
    }
    
    //This is an action that animates the walking wit the textures and updates the walking animation every 0.1 seconds. The player then also has an action that will play the action sound forever while the game is being played.
    _playerAnimation = [SKAction animateWithTextures:walking timePerFrame:0.1];
    _walking = [SKAction repeatActionForever:_walkingSound];
    
    [_player runAction:_walking withKey:@"walking"];
    [_player runAction:[SKAction repeatActionForever:_playerAnimation] withKey:@"animation"];
}

//This method is used to make the character jump whenever the screen is tapped. The method starts by turning off the touches so a player cannot just continue jumping and also removes the walking sound. I then set the jump height, and how long it should last and then reverse the action to bring the player back down to the ground. I also set a jump wait time to make sure the user is back on the ground before they can jump again. After that the action runs a block that turns on touches again and the walking action is played again. When put all together the sequence is run.
-(void)playerJumpingAnimation{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [self setUserInteractionEnabled:NO];
        [ _player removeActionForKey:@"walking"];
        
        SKAction *jumpHeight = [SKAction moveToY:190 duration:.15];
        SKAction *returnToGround = [jumpHeight reversedAction];
        SKAction *waitToJump = [SKAction waitForDuration:.4];
        SKAction *enableTouches = [SKAction runBlock:^{
            
            self.userInteractionEnabled = YES;
            [_player runAction:_walking withKey:@"walking"];
            
        }];
        
        SKAction *jumping = [SKAction sequence:@[jumpHeight, _jumpSound, returnToGround, waitToJump, enableTouches]];
        
        [_player runAction:jumping withKey:@"jumping"];
        
    }
    
}

-(void)playerSuperJumpingAnimation{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        [self setUserInteractionEnabled:NO];
        [ _player removeActionForKey:@"walking"];
        
        SKAction *jumpHeight = [SKAction moveToY:225 duration:.15];
        SKAction *returnToGround = [jumpHeight reversedAction];
        SKAction *waitToJump = [SKAction waitForDuration:.5];
        SKAction *enableTouches = [SKAction runBlock:^{
            
            self.userInteractionEnabled = YES;
            [_player runAction:_walking withKey:@"walking"];
            
        }];
        
        SKAction *jumping = [SKAction sequence:@[jumpHeight, _jumpSound, returnToGround, waitToJump, enableTouches]];
        
        [_player runAction:jumping withKey:@"jumping"];
        
    }
    
}

#pragma mark Obstacle Methods

//This method is used to create the bees. Two random numbers are generated for the x and y axis, the x is to make sure they are spread out and spawn off of the screen. And the y axis is to give them some variation in height to the bees. Finally the bee category is mixed, collision is set and also set to colide only with the player. Finally an action is made to move the bees from right to left on the screen and that it is set to take 11 seconds. The anitmations are setup like the player animations, please see that comment for how it works.
-(void)addBee{
    
    SKTextureAtlas *atlas = [self textureAtlas:@"sprites"];
    _bee = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"bee1"]];
    _bee.scale = 0.55;
    _bee.name = @"bee";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        float randomPhoneX = [self randomNumber:850 andValue:900];
        float randomPhoneY = [self randomNumber:100 andValue:130];
        _bee.position = CGPointMake(randomPhoneX, randomPhoneY);
        
        CGPoint location = CGPointMake(-self.frame.size.width + _bee.size.width/2, 100);
        
        _beeMoving = [SKAction moveTo:location duration:6];
        [_bee runAction:_beeMoving withKey:@"moveBee"];
        
    }
    
    [_beeNode addChild:_bee];

    _bee.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_bee.frame.size];
    _bee.physicsBody.categoryBitMask = beeCategory;
    _bee.physicsBody.collisionBitMask = 0;
    _bee.physicsBody.contactTestBitMask = playerCategory;
    _bee.physicsBody.dynamic = NO;
    
    NSMutableArray *animation = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 1; i < 3; i++){
        
        NSString *textureName = [NSString stringWithFormat:@"bee%d", i];
        SKTexture *textures = [SKTexture textureWithImageNamed:textureName];
        [animation addObject:textures];
        
    }
    
    for (int i = 2; i > 0; i--){
        
        NSString *textureName = [NSString stringWithFormat:@"bee%d", i];
        SKTexture *textures = [SKTexture textureWithImageNamed:textureName];
        [animation addObject:textures];
        
    }
    
    _beeAnimation = [SKAction animateWithTextures:animation timePerFrame:0.15];
    
    [_bee runAction:[SKAction repeatActionForever:_beeAnimation] withKey:@"beeAnimation"];
    
}

//This is used to start spawning bees, this is much like the coin spawn, please see comments there.
-(void)startSpawningBees{
    
    SKAction *delayTime = [SKAction waitForDuration:obstacleDelay];
    SKAction *spawnObstacle = [SKAction performSelector:@selector(addBee) onTarget:self];
    SKAction *spawnDelay = [SKAction waitForDuration:[self randomNumber:obstacleUpdateMinTime andValue:obstableUpdateMaxTime]];
    
    SKAction *spawnSequence = [SKAction sequence:@[spawnObstacle, spawnDelay]];
    SKAction *spawnForever = [SKAction repeatActionForever:spawnSequence];
    SKAction *completeSpawnSequence = [SKAction sequence:@[delayTime, spawnForever]];
    
    [self runAction:completeSpawnSequence withKey:@"beeSpawn"];
    
}

#pragma mark Setup Hearts

-(void)setupHeartOne{
    
    //Creates a node, and then sets it to the image heart
    SKTextureAtlas *heartAtlas = [self textureAtlas:@"sprites"];
    _heartOne = [SKSpriteNode spriteNodeWithTexture:[heartAtlas textureNamed:@"heart"]];
    
    //This Will add in the first heart to the scene
    _heartOne.position = CGPointMake(25, self.size.height - 25);
    _heartOne.scale = 0.2;
    _heartOne.physicsBody.dynamic = NO;
    _heartOne.name = @"heartOne";
    
    //This adds the node to the scene
    [_heartsUINode addChild:_heartOne];
    
}

-(void)setupHeartTwo{
    
    //Creates a node, and then sets it to the image heart
    SKTextureAtlas *heartAtlas = [self textureAtlas:@"sprites"];
    _heartTwo = [SKSpriteNode spriteNodeWithTexture:[heartAtlas textureNamed:@"heart"]];
    
    //This Will add in the first heart to the scene
    _heartTwo.position = CGPointMake(50, self.size.height - 25);
    _heartTwo.scale = 0.2;
    _heartTwo.physicsBody.dynamic = NO;
    _heartTwo.name = @"heartOne";
    
    //This adds the node to the scene
    [_heartsUINode addChild:_heartTwo];
    
}

-(void)setupHeartThree{
    
    //Creates a node, and then sets it to the image heart
    SKTextureAtlas *heartAtlas = [self textureAtlas:@"sprites"];
    _heartThree = [SKSpriteNode spriteNodeWithTexture:[heartAtlas textureNamed:@"heart"]];
    
    //This Will add in the first heart to the scene
    _heartThree.position = CGPointMake(75, self.size.height - 25);
    _heartThree.scale = 0.2;
    _heartThree.physicsBody.dynamic = NO;
    _heartThree.name = @"heartOne";
    
    //This adds the node to the scene
    [_heartsUINode addChild:_heartThree];
    
}

-(void)addHeart {
    
    SKTextureAtlas *atlas = [self textureAtlas:@"sprites"];
    _hearts = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"heart"]];
    
    //This will give the node a name so it can be used for touches.
    _hearts.name = @"hearts";
    
    //This will scale the node/image to the size I feel is good for the game.
    _hearts.scale = 0.15;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
        float randomPhoneX = [self randomNumber:900 andValue:1200];
        float randomPhoneY = [self randomNumber:100 andValue:190];
        _hearts.position = CGPointMake(randomPhoneX, randomPhoneY);
        
        CGPoint location = CGPointMake(-self.frame.size.width + _hearts.size.width/2, 100);
        
        SKAction *moving = [SKAction moveTo:location duration:15];
        [_hearts runAction:moving withKey:@"moveHeart"];
        
    }
    
    _hearts.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_hearts.frame.size];
    _hearts.physicsBody.dynamic = NO;
    
    //This sets the Catergoy to the coinCategory, sets it so it can be collided with and finally sets it that it should only colide with the player.
    _hearts.physicsBody.categoryBitMask = heartCategory;
    _hearts.physicsBody.collisionBitMask = 0;
    _hearts.physicsBody.contactTestBitMask = playerCategory;
    
    [_heartsUINode addChild:_hearts];
    
}

-(void)startSpawningHearts{
    
    SKAction *heartDelayTime = [SKAction waitForDuration:heartDelay];
    SKAction *spawnHeart = [SKAction performSelector:@selector(addHeart) onTarget:self];
    SKAction *spawnHeartDelay = [SKAction waitForDuration:[self randomNumber:heartUpdateMin andValue:heartUpdateMax]];
    
    SKAction *heartSpawnSequence = [SKAction sequence:@[spawnHeart, spawnHeartDelay]];
    SKAction *heartSpawnForever = [SKAction repeatActionForever:heartSpawnSequence];
    SKAction *completeHeartSequence = [SKAction sequence:@[heartDelayTime, heartSpawnForever]];
    
    [self runAction:completeHeartSequence withKey:@"heartSpawn"];
    
}


#pragma mark Setup Methods

//This method is used to setup the music player to be able to play the background music for the game.
-(void)playMusic:(NSString *)file{
    
    NSError *error;
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:file withExtension:nil];
    
    _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
    _musicPlayer.numberOfLoops = -1;
    
    [_musicPlayer prepareToPlay];
    [_musicPlayer play];
    
}

//This method is called when the view is loaded so all the sounds are preloaded.
-(void)setupSound{
    
    _jumpSound = [SKAction playSoundFileNamed:@"jump.caf" waitForCompletion:NO];
    _coinSound = [SKAction playSoundFileNamed:@"coin.caf" waitForCompletion:NO];
    _walkingSound = [SKAction playSoundFileNamed:@"walking.caf" waitForCompletion:YES];
    _deathSound = [SKAction playSoundFileNamed:@"death.caf" waitForCompletion:NO];
    
}

//This method sets up the score label to keep track of how many coins have been colllected.
-(void)setupScoreLabel{
    
    _score = [[SKLabelNode alloc] initWithFontNamed:fontName];
    _score.fontColor = [UIColor colorWithRed:0.114 green:0.443 blue:0.667 alpha:1];
    _score.position = CGPointMake(self.size.width / 2, self.size.height - 15);
    _score.text = [NSString stringWithFormat:@"Coins Collected: %lu", (unsigned long)_coinsCollected];
    _score.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    [_sceneNode addChild:_score];
    
}

-(SKSpriteNode *)pauseButton{
    
    SKSpriteNode *pause = [SKSpriteNode spriteNodeWithImageNamed:@"pause"];
    pause.position = CGPointMake(self.size.width - 25, self.size.height - 25);
    pause.name = @"pause";
    pause.zPosition = 1;
    pause.scale = 0.50;
    
    return pause;
    
}

-(SKSpriteNode *)playButton{
    
    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"right"];
    play.position = CGPointMake(self.size.width - 25, self.size.height - 25);
    play.name = @"play";
    play.zPosition = 1;
    play.scale = 0.50;
    
    return play;
    
}

#pragma mark Stop Action Method

//This is called to stop both the coins and bee spawning actions.
-(void)stopAction{
    
    [self removeActionForKey:@"coinSpawn"];
    [self removeActionForKey:@"beeSpawn"];
    [self removeActionForKey:@"heartSpawn"];
    
}

#pragma mark Helper Methods

//This method is used to create the random numbers used through the game.
- (float)randomNumber:(float)low andValue:(float)high {
    
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
    
}

-(void)pauseGame{
    
    _sceneNode.paused = YES;
    _beeNode.paused = YES;
    _coinNode.paused = YES;
    _playerNode.paused = YES;
    self.paused = YES;
    [_musicPlayer pause];
    _playing = FALSE;
    
}

-(void)playGame{
    
    _sceneNode.paused = NO;
    _beeNode.paused = NO;
    _coinNode.paused = NO;
    _playerNode.paused = NO;
    [self startSpawningBees];
    [self startSpawningCoins];
    self.paused = NO;
    [_musicPlayer play];
    _playing = TRUE;

    
}

-(void)reportAchievements{
    
    NSMutableArray *achieves = [NSMutableArray array];
    
    [achieves addObject:[AchievementHelpr coinsCollected:_coinsCollected]];
    
    [[GameKitHelper sharedHelper] sendAchievements:achieves];
    
}

-(void)reportCoins{
    
    int64_t coinsCollected = _coinsCollected;
    [[GameKitHelper sharedHelper] reportCoins:coinsCollected :@"com.wwdstudios.GetMeOuttaHere.leaderboard"];
    
}

//This is called to figure out which texture atlas needs to be used to get the correct images for the game depending on the device, either iPad or iPhone.
-(SKTextureAtlas *)textureAtlas:(NSString *)file{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
        file = [NSString stringWithFormat:@"%@-iPhone", file];

    }
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:file];
    
    return atlas;
    
}

#pragma mark Contact Methods

//This method is to check for any collisions.
-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody *getBody = (contact.bodyA.categoryBitMask == playerCategory ?  contact.bodyB : contact.bodyA);
    
    //This sets the _playing to NO so when the update happens it stops actions and the ground from moving. It also pauses the nodes for the bees, coins and players so that it does appear that the game is over and the user can no longer interact with the player. Finally the music is changed to play a game over music and displays the game over label.
    if (getBody.categoryBitMask == beeCategory){
        
        if (_heartThree != nil){
            
            [contact.bodyB.node removeFromParent];
            [_heartThree removeFromParent];
            _heartThree = nil;
            
        }  else if (_heartThree == nil && _heartTwo != nil){
            
            [contact.bodyB.node removeFromParent];
            [_heartTwo removeFromParent];
            _heartTwo = nil;
            
        } else if (_heartThree == nil && _heartTwo == nil && _heartOne != nil){
        
            _playing = NO;
            _coinNode.paused = YES;
            _beeNode.paused = YES;
            _playerNode.paused = YES;
            [self runAction:_deathSound];
            [_musicPlayer stop];
            [_pausePlayNode removeAllChildren];
            [self reportCoins];
            
            GameOver *gameover = [GameOver  sceneWithSize:self.frame.size];
            gameover.coinsCollected = _coinsCollected;
            SKTransition *gameoverTransition = [SKTransition fadeWithDuration:1.5];
            [self.view presentScene:gameover transition:gameoverTransition];
            
        }
    
    }
    
    //This checks to see if the player has made contact with a coin on the screen, if the player has the coin sound is played and the coin is removed from the screen. A coin int is then added to increase the number and the label is updated to show the correct amount of coins collected.
    if (getBody.categoryBitMask == coinCategory){
        
        [self runAction:_coinSound];
        [contact.bodyB.node removeFromParent];
        _coinsCollected ++;
        _score.text = [NSString stringWithFormat:@"Coins Collected: %lu", (unsigned long)_coinsCollected];
        [self reportAchievements];
        
    }
    
    if (getBody.categoryBitMask == heartCategory){
        
        if (_heartThree != nil){
         
             [contact.bodyB.node removeFromParent];
            NSLog(@"Full Health");
            
        } else if (_heartThree == nil && _heartTwo != nil){
            
             [contact.bodyB.node removeFromParent];
            [self setupHeartThree];
            NSLog(@"Got Third Heart");
            
        } else if (_heartThree == nil && _heartTwo == nil && _heartOne != nil){
            
            [contact.bodyB.node removeFromParent];
            [self setupHeartTwo];
            NSLog(@"Got Second Heart");
            
        }
        
    }
    
}

@end
