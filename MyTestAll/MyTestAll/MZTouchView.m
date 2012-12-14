//
//  MZTouchView.m
//  MyTestAll
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MZTouchView.h"


unsigned char *_buffer = NULL;
unsigned _length = 0;

@implementation MZTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    
    _bMouseDown = false;
    
    const unsigned length = 960*640*3 + 128;
    if (_buffer == NULL) {
        NSString *bmpFilePath = [[NSBundle mainBundle] pathForResource:@"10032.bmp" ofType:nil];
        FILE *pf =  fopen(bmpFilePath.UTF8String, "rb");
        if (pf != NULL) {
            _buffer = (unsigned char*)malloc(length);
            
            
            fseek(pf, 0, SEEK_END);
            long len = ftell(pf);
            fseek(pf, 0, SEEK_SET);
            fread(_buffer, len, 1, pf);
            fclose(pf);
            
            int nHeight = *(int*)(_buffer+22);
            *(int*)(_buffer+22) = -nHeight;
            _length = 54 + (640*832*3);
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	//_bDrawing = true;
	[super drawRect:rect];
	
	if (_length != 0 && _buffer != NULL) {
        NSData *nsData = [NSData dataWithBytesNoCopy:_buffer length:_length freeWhenDone:NO];
		UIImage *uiImage = [UIImage imageWithData:nsData]; 
		CGImageRef imageRef = CGImageRetain(uiImage.CGImage);
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGRect imageRect;
		imageRect.origin = CGPointMake(0.0, 0.0);
        imageRect.size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
		CGContextDrawImage(context, imageRect, imageRef);
		CGImageRelease(imageRef);
        uiImage = nil;
        nsData = nil;
	}
	//_bDrawing = false;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{ 

}

// Handles the continuation of a touch.
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}



-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


@end
