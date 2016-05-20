//
//  Macros.h
//  Mak
//
//  Created by Alex Restrepo on 5/13/16.
//  Copyright © 2016 restrepo. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

//http://stackoverflow.com/questions/1034373/creating-an-abstract-class-in-objective-c
#define AR_ABSTRACT_METHOD {\
    [self doesNotRecognizeSelector:_cmd]; \
    __builtin_unreachable(); \
}

#if DEBUG
    static inline void log_imp( const char *filePath, const int lineNumber, NSString *format, ... )
    {
        va_list ap;
        va_start( ap, format );
        NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end( ap );
        
        NSString *fileName = [[NSString stringWithUTF8String:filePath] lastPathComponent];
        fprintf( stderr, "%s:%d > %s\n",
                [fileName UTF8String],
                lineNumber, [body UTF8String] );
    }

    #define DebugLog(args...) do {              \
    log_imp( __FILE__, __LINE__, args );    \
    } while (0)

#else
    #define DebugLog(args...)
#endif

#endif /* Macros_h */
