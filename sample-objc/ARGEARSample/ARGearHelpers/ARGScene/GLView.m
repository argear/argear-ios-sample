//
//  GLView.m
//  ARGEARSample
//
//  Created by Jihye on 23/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "GLView.h"
#import <OpenGLES/EAGL.h>
#import <QuartzCore/CAEAGLLayer.h>
#import "ShaderUtilities.h"

#if !defined(_STRINGIFY)
#define __STRINGIFY( _x )   # _x
#define _STRINGIFY( _x )   __STRINGIFY( _x )
#endif

static const char * kPassThruVertex = _STRINGIFY(
    attribute vec4 position;
    attribute mediump vec4 texturecoordinate;
    varying mediump vec2 coordinate;

    void main() {
        gl_Position = position;
        coordinate = texturecoordinate.xy;
    }
);

static const char * kPassThruFragment = _STRINGIFY(
    varying highp vec2 coordinate;
    uniform sampler2D videoframe;

    void main() {
        gl_FragColor = texture2D(videoframe, coordinate);
    }
);

enum {
    ATTRIB_VERTEX,
    ATTRIB_TEXTUREPOSITON,
    NUM_ATTRIBUTES
};

@interface GLView() {
    CVOpenGLESTextureCacheRef textureCache;

    GLint width;
    GLint height;

    GLuint frameBufferHandle;
    GLuint colorBufferHandle;
    
    GLuint program;
    GLint _frame;
}
@property (nonatomic, strong) EAGLContext *eaglContext;
@end

@implementation GLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([UIScreen instancesRespondToSelector:@selector(nativeScale)]) {
            self.contentScaleFactor = [UIScreen mainScreen].nativeScale;
        } else
#endif
        {
            self.contentScaleFactor = [UIScreen mainScreen].scale;
        }
        
        // Initialize OpenGL ES 2
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO],
                                        kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8,
                                        kEAGLDrawablePropertyColorFormat,
                                        nil];
        
        _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        _useRenderer = YES;
        
        if (! _eaglContext) {
            _useRenderer = NO;
            return nil;
        }
    }
    return self;
}

- (BOOL)initializeBuffers {
    BOOL success = YES;
    
    glDisable( GL_DEPTH_TEST );
    
    glGenFramebuffers(1, &frameBufferHandle);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBufferHandle);
    
    glGenRenderbuffers(1, &colorBufferHandle);
    glBindRenderbuffer(GL_RENDERBUFFER, colorBufferHandle);
    
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorBufferHandle);
    if (glCheckFramebufferStatus( GL_FRAMEBUFFER ) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failure with framebuffer generation %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));

        success = NO;
        goto bail;
    }
    
    //  Create a new CVOpenGLESTexture cache
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, _eaglContext, NULL, &textureCache);
    if (err) {
        NSLog(@"Error at CVOpenGLESTextureCacheCreate %d", err);
        success = NO;
        goto bail;
    }
    
    // attributes
    GLint attribLocation[NUM_ATTRIBUTES] = {
        ATTRIB_VERTEX,
        ATTRIB_TEXTUREPOSITON,
    };
    GLchar *attribName[NUM_ATTRIBUTES] = {
        "position",
        "texturecoordinate",
    };
    
    glueCreateProgram(
                      kPassThruVertex,
                      kPassThruFragment,
                      NUM_ATTRIBUTES,
                      (const GLchar **)&attribName[0], attribLocation,
                      0,
                      0,
                      0,
                      &program
                      );
    
    if (!program) {
        NSLog(@"Error creating the program");
        success = NO;
        goto bail;
    }
    _frame = glueGetUniformLocation(program, "videoframe");

bail:
    if (!success) {
        [self clean];
    }
    return success;
}

- (void)clean {
    if (frameBufferHandle) {
        glDeleteFramebuffers(1, &frameBufferHandle);
        frameBufferHandle = 0;
    }
    if (colorBufferHandle) {
        glDeleteRenderbuffers(1, &colorBufferHandle);
        colorBufferHandle = 0;
    }
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
    if (textureCache) {
        CFRelease(textureCache);
        textureCache = 0;
    }
}

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if(!_useRenderer) {
        return;
    }
    
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f, // bottom left
        1.0f, -1.0f, // bottom right
        -1.0f,  1.0f, // top left
        1.0f,  1.0f, // top right
    };
    
    if ( pixelBuffer == NULL ) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"NULL pixel buffer" userInfo:nil];
        return;
    }
    
    EAGLContext *oldContext = [EAGLContext currentContext];
    if ( oldContext != _eaglContext ) {
        if ( ! [EAGLContext setCurrentContext:_eaglContext] ) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Problem with OpenGL context" userInfo:nil];
            return;
        }
    }
    
    if ( frameBufferHandle == 0 ) {
        BOOL success = [self initializeBuffers];
        if ( ! success ) {
            NSLog(@"Problem initializing OpenGL buffers.");
            return;
        }
    }
    
    // Create a CVOpenGLESTexture from a CVPixelBufferRef
    size_t frameWidth = CVPixelBufferGetWidth( pixelBuffer );
    size_t frameHeight = CVPixelBufferGetHeight( pixelBuffer );
    CVOpenGLESTextureRef texture = NULL;
    CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage( kCFAllocatorDefault,
                                                                textureCache,
                                                                pixelBuffer,
                                                                NULL,
                                                                GL_TEXTURE_2D,
                                                                GL_RGBA,
                                                                (GLsizei)frameWidth,
                                                                (GLsizei)frameHeight,
                                                                GL_BGRA,
                                                                GL_UNSIGNED_BYTE,
                                                                0,
                                                                &texture );
    
    
    if ( ! texture || err ) {
        NSLog(@"CVOpenGLESTextureCacheCreateTextureFromImage failed (error: %d)", err);
        return;
    }
    
    // Set the view port to the entire view
    glBindFramebuffer( GL_FRAMEBUFFER, frameBufferHandle );
    glViewport( 0, 0, width, height );
    
    glUseProgram( program );
    glActiveTexture( GL_TEXTURE0 );
    glBindTexture( CVOpenGLESTextureGetTarget( texture ), CVOpenGLESTextureGetName( texture ) );
    glUniform1i( _frame, 0 );
    
    // Set texture parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    
    glVertexAttribPointer( ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices );
    glEnableVertexAttribArray( ATTRIB_VERTEX );
    
    CGSize textureSamplingSize;
    CGSize cropScaleAmount = CGSizeMake( width / (float)frameWidth, height / (float)frameHeight );
    if ( cropScaleAmount.height > cropScaleAmount.width ) {
        textureSamplingSize.width = width / ( frameWidth * cropScaleAmount.height );
        textureSamplingSize.height = 1.0;
    }
    else {
        textureSamplingSize.width = 1.0;
        textureSamplingSize.height = height / ( frameHeight * cropScaleAmount.width );
    }
    
    CGPoint one, two, three, four;
    
    //    if(_isFrontCamera){
    //        one.x = (1.0 - textureSamplingSize.width)/2.0; one.y = (1.0 - textureSamplingSize.height)/2.0;
    //        two.x = (1.0 + textureSamplingSize.width)/2.0; two.y = (1.0 - textureSamplingSize.height)/2.0;
    //        three.x = (1.0 - textureSamplingSize.width)/2.0; three.y = (1.0 + textureSamplingSize.height)/2.0;
    //        four.x = (1.0 + textureSamplingSize.width)/2.0; four.y = (1.0 + textureSamplingSize.height)/2.0;
    //    } else {
    one.x = (1.0 - textureSamplingSize.width)/2.0; one.y = (1.0 + textureSamplingSize.height)/2.0;
    two.x = (1.0 + textureSamplingSize.width)/2.0; two.y = (1.0 + textureSamplingSize.height)/2.0;
    three.x = (1.0 - textureSamplingSize.width)/2.0; three.y = (1.0 - textureSamplingSize.height)/2.0;
    four.x = (1.0 + textureSamplingSize.width)/2.0; four.y = (1.0 - textureSamplingSize.height)/2.0;
    //    }
    
    GLfloat passThroughTextureVertices[] = {
        one.x, one.y, // top left
        two.x, two.y, // top right
        three.x, three.y, // bottom left
        four.x, four.y, // bottom right
    };
    
    //    GLfloat passThroughTextureVertices[] = {
    //        ( 1.0 - textureSamplingSize.width ) / 2.0, ( 1.0 + textureSamplingSize.height ) / 2.0, // top left
    //        ( 1.0 + textureSamplingSize.width ) / 2.0, ( 1.0 + textureSamplingSize.height ) / 2.0, // top right
    //        ( 1.0 - textureSamplingSize.width ) / 2.0, ( 1.0 - textureSamplingSize.height ) / 2.0, // bottom left
    //        ( 1.0 + textureSamplingSize.width ) / 2.0, ( 1.0 - textureSamplingSize.height ) / 2.0, // bottom right
    //    };
    
    glVertexAttribPointer( ATTRIB_TEXTUREPOSITON, 2, GL_FLOAT, 0, 0, passThroughTextureVertices);
    glEnableVertexAttribArray( ATTRIB_TEXTUREPOSITON );
    
    glDrawArrays( GL_TRIANGLE_STRIP, 0, 4 );
    
    glBindRenderbuffer( GL_RENDERBUFFER, colorBufferHandle );
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
    
    glBindTexture( CVOpenGLESTextureGetTarget( texture ), 0 );
    glBindTexture( GL_TEXTURE_2D, 0 );
    CFRelease( texture );
    
    glUseProgram(0); //unbind the shader
    glBindFramebuffer(GL_FRAMEBUFFER, 0); //unbind the FBO
    
    
    if ( oldContext != _eaglContext ) {
        [EAGLContext setCurrentContext:oldContext];
    }
}

- (void)flushPixelBufferCache {
    if (textureCache) {
        CVOpenGLESTextureCacheFlush(textureCache, 0);
    }
}

- (void)reset {
    EAGLContext *oldContext = [EAGLContext currentContext];
    if (oldContext != _eaglContext) {
        if (![EAGLContext setCurrentContext:_eaglContext]) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Problem with OpenGL context" userInfo:nil];
            return;
        }
    }
    
    [self clean];
    
    if (oldContext != _eaglContext) {
        [EAGLContext setCurrentContext:oldContext];
    }
}

- (void)dealloc {
    [self reset];
    [self setEaglContext:nil];
}

@end
