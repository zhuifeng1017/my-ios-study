//
//  CTView.m
//  MyTestAll
//
//  Created by uistrong on 12-12-4.
//
//

#import "CTView.h"
#import <CoreText/CoreText.h>
#import "MarkupParser.h"

@implementation CTView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code 
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );
    
//    NSAttributedString* attString = [[NSAttributedString alloc]
//                                      initWithString:@"Hello core text world!"]; //2
    
    MarkupParser* p = [[MarkupParser alloc] init] ;
    NSAttributedString* attString = [p attrStringFromMarkup: @"Hello <font color=\"red\">core text <font color=\"blue\">world!"];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString); //3
    CTFrameRef frame =CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context); //4
    
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
    
}


@end
